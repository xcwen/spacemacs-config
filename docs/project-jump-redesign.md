# `,a` 跳转检查与重新设计

检查日期：2026-11-09。范围：spacemacs-config、aigc-php-core、aigc-vue、node-core、rust-core、go-core。

本方案已实现：共享 Rust proto-gen 输出索引，Emacs 配置加载、语言适配器、前端关系索引和新快捷键均已接入。按要求重新设计，不兼容旧 `.env` 跳转键、`SWITCH-TO`、`ACTION-SWITCH-TO` 或旧辅助函数语义。第 1 节保留重构前的检查记录，行号对应原实现。

## 1. 现状与确定的问题

入口：`my-config.el:201` 将 `,a` 绑定到 `switch-file-opt`，`,A` 绑定到 `switch-file-opt-proto`。

`switch-file-opt`（`xcwen-misc.el:1338–1609`）实际顺序：

1. 向上查找 `.env`，从文件头搜索第一个 `SWITCH-TO:`，处理后缀、路径和目录。
2. PHP Controller：取当前方法，尝试 action 注释、Vue 页面，再尝试 proto。
3. Go：取 receiver 方法，尝试 Vue，再尝试 proto。
4. Node Controller：向前搜索 `async`，优先找同路径 `.ts` 页面，再尝试 proto。
5. 普通 TS：读取同名 Vue 中的 `url =`，尝试后端，再回退同名 `.vue` / `.wxml`。
6. Vue：尝试同名 `.ts`。proto：优先 PHP Controller，缺失才找 Node Controller。
7. 目标存在才打开，之后用正则定位方法。

| 问题 | 依据与影响 |
| --- | --- |
| 路由分流过时 | `get-url-path-goto-info:686` 只把 `route__menu_similarity` 分给 Node；真实 Nginx `tools/docker/nginx/conf.d/route.conf:92` 有六个 Node 前缀，含 `route__node_admin`。例如 LlmSubmit.vue 的 submit 会被按 PHP 路径推导。 |
| URL 提取不可靠 | `switch-file-opt-ts-url:653` 使用外部 `grep`，模式含 `+` 却没有启用扩展正则；只读磁盘同名 `.vue`、只认赋值、只移除双引号。引号、分号、空格路径、未保存编辑、缺少同名 Vue 都可能失败。 |
| 新页面没有同名 TS | `src/views/admin/notify/task_list.vue` 直接用 `<script setup>`，不存在 task_list.ts；接口藏在导入的 `notify_task_crud_spec.urls`，旧 Vue 分支只尝试同名 TS。 |
| 文件路径不等于 API | `LlmSubmit.vue`、`LlmRecords.vue` 等组件名与 action 不对应；一个页面也可能调用多个后端或多个接口。 |
| action 注释可能抢占全局跳转 | 文件头的无边界 `SWITCH-TO:` 搜索也会匹配 `ACTION-SWITCH-TO:` 的子串，跳转可能受另一个方法的注释影响。 |
| 回退路径发生串联 | `switch-file-opt:1366–1375` 将前一次映射后的路径继续交给下一套映射，未保留原始逻辑路径。 |
| 映射按首个前缀匹配 | `get-route-jump-file-name:670` 不按最长匹配、不检查路径段边界，空前缀还可能遮蔽具体规则。 |
| 根目录依赖业务环境文件 | `get-project-root-dir:2334` 和 `go-core-server--get-project-root-dir:2365` 都以 `.env` 为界。缺失时返回 nil，后续字符串拼接不能保证指向当前仓库。 |
| Go 布局已经变化 | 当前项目是 `internal/controllers`；旧 proto 回跳只找 PHP、Node，旧 Go proto 路径硬编码 `../../proto/src/`，多级目录不成立。 |
| Rust 没有处理分支 | `.rs` 和 rust-mode/rust-ts-mode 均无对应规则。 |
| 方法定位易报错 | Node 向前搜索 `async` 和最后的目标方法搜索没有 NOERROR；首个方法、同步方法、缺少方法可能触发 search-failed。PHP 依赖 ac-php 内部函数。 |
| 缺少统一返回和解释 | 命令自身没有在跳转前压入 xref 栈；目标不存在通常静默结束，也无法查看候选来自哪条规则。 |

上述是代码与本地文件对照结论，未宣称已在运行中的 Spacemacs 内复现所有交互行为。

## 2. 设计决定

使用“工作区项目图 + 接口索引 + 语言适配器”，将文件识别、关系解析、候选选择、打开定位拆开。主命令不再维护一串按 major-mode 分支的业务规则。

接口地址以结构化字段表示：

```text
project = go
id      = root/test/user_list
method  = GET
```

`id` 是去掉网关前缀后的完整逻辑接口名，保留项目分组。完整身份由后端项目、id 和 HTTP method 组成；允许同接口在 PHP、Node、Rust、Go 中分别实现。URL 是索引中的别名，不代替完整身份；自定义 HTTP path、短路径必须由生成器输出别名，编辑器不猜测。

统一上下文返回 `project/file/role/endpoint/source-range`，候选返回 `target-project/file/symbol/endpoint/reason/priority`。解析阶段不打开文件、不移动光标、不保存缓冲区。最后一个执行函数负责候选验证、xref 入栈、打开、定位。

### `,a` 与 `,A` 的新语义

`,a` 选择当前上下文的关联目标，规则按下列顺序处理：

| 当前上下文 | 默认目标 |
| --- | --- |
| Vue/TS 光标位于已识别请求或 spec 引用 | 对应后端的 Controller 方法；多个接口提示选择。 |
| Vue/TS 的其他位置 | 先选精确文件绑定的接口；没有绑定则找同名 `.vue` / `.ts`；再列出当前文件中已识别的接口。没有结果时解释原因。 |
| 后端 Controller 的接口方法内部 | 优先已建立反向关系的前端页面；没有页面则到本后端 proto。多个页面提示选择。 |
| proto 的接口文件 | 只到所属后端的 Controller 方法。公共消息 proto 不拼造 Controller 路径。 |
| 普通文件或 Controller 辅助方法 | 仅提供显式关系和同名配套文件；没有接口上下文不猜上一段 async。 |

`,A` 专门打开当前接口所属后端的 proto；请求处有多个候选时选择接口。proto 本身不重复打开。`C-u ,a` 列出所有关联页面、proto、Controller 以及其他后端的同逻辑接口，明确显示项目与目标类型。

同优先级多候选使用 `completing-read`，显示例如 `[go] Controller root/test/user_list → TestController.UserList`；不依赖目录遍历顺序。单个结果直接打开；零结果使用 `user-error` 给出可操作原因。缺少目标文件不创建文件；文件存在但方法缺失时只到文件开头并提示定位失败。成功打开前压入 xref 栈，统一用 `xref-go-back` 返回。

## 3. 五个项目的适配规则

四个后端均已使用 `proto/generator.toml`。其中 `source`、`controllers` 等相对路径应相对 TOML 所在目录解析，不能相对仓库根解析。

| 项目 | Controller 根目录 | proto 根目录 | 文件与符号示例 |
| --- | --- | --- | --- |
| aigc-php-core | `src/app/Controllers` | `proto/src` | `Admin/Notify.php` → `Notify::task_list` |
| node-core | `src/controllers` | `proto/src` | `partner/data.ts` → `user_list` |
| rust-core | `apps/rust-server/src/controllers` | `proto/src` | `root/test.rs` → `Test::user_list`，限对应 impl 块 |
| go-core | `internal/controllers` | `proto/src` | `root/test.go` → `TestController.UserList`，限对应 receiver |
| aigc-vue | `src/views`、`src/partner` | 不适用 | SFC、独立 TS、请求函数封装、CRUD spec 导入 |

Go 的 `user_list → UserList` 与 Rust 的 `user_list → user_list` 已由本地源码、注册代码确认。PHP 的分组和控制器使用 PascalCase 路径。命名转换只作为适配器规则；具体接口索引提供实际符号，缩写、保留字等例外不靠粗略 snake_case 转换修补。

当前实现使用独立于 major-mode 的受限声明扫描，校验方法所属 class/impl/receiver 及函数范围，跳过注释、字符串、TS 正则和 Rust 原始字符串，并排除嵌套函数上下文。Vue 只解析 script 块。这里的“适配器”针对语言，不针对项目名；新项目复用适配器即可。

## 4. 接口索引：复用统一生成器

当前已有产物并不完全统一：

- PHP：`src/gen/Proto/cmd.json`，主要是 `cmd_list[].NAME` 等元信息。
- Node：`src/gen/cmd.json` 同上；`proto_info.json` 是结构信息，不是文件/方法跳转索引。
- Rust：`apps/rust-server/src/gen/proto/api.json`，已有 `source/path/method`。
- Go：`gen/proto/api.json`，已有 `source/path/method`。
- `.proto-gen-manifest.json` 是生成文件列表，不是接口到 Controller 的映射。

共享 Rust `proto-gen` 现已输出统一的 `proto/navigation.json`，直接利用生成器已经掌握的解析结果。该文件参与生成清单、增量校验和只读 `--check`，四个后端均已生成。

索引版本 1 的结构：

```json
{
  "version": 1,
  "endpoints": [
    {
      "id": "root/test/user_list",
      "method": "GET",
      "paths": ["/root/test/user_list"],
      "proto": "proto/src/root/test__user_list.proto",
      "controller": {
        "file": "internal/controllers/root/test.go",
        "owner": "TestController",
        "symbol": "UserList"
      }
    }
  ]
}
```

所有文件路径相对后端仓库根，`project` 由工作区注册项赋予，同一仓库不同 checkout 可以使用同一索引内容。行号不作为唯一依据，打开时重新定位符号，以免业务代码编辑使行号失效。`paths` 包含真实 HTTP path 和合法别名，由生成器按实际路由规则输出。路径别名冲突或存在不同 method 时保留全部候选。

新索引不存在时，命令明确提示该后端索引待生成；不自动执行脚本或退回旧逻辑。新版生成器的 `generate --check` 已覆盖该索引的一致性检查。

## 5. 工作区配置

完整五项目示例见 `../examples/project-jump.workspace.json`。本机已安装为 `~/.config/emacs/project-jump/workspaces/aigc.json`；未安装本机配置时，默认读取仓库内示例。

推荐本机入口：`~/.config/emacs/project-jump/workspaces/aigc.json`，由一个 `defcustom xcwen-jump-workspace-files` 指定配置文件列表。不要读取业务 `.env`，也不自动执行项目内 Lisp。

配置职责：

- `projects`：稳定 ID、仓库位置、语言适配器、生成器配置与索引位置。
- `gateway`：已知网关前缀到后端的精确映射，剥离 `/api` 时要求路径段边界。按完整路径段最长前缀匹配。
- `requests`：声明请求 API 的导入来源、导出名、URL 参数位置和固定后端；通过导入绑定识别别名，不能只匹配一个同名函数。
- `specProviders`：从指定来源的导出对象读取 `urls.list/urls.opt` 等静态字段；解析静态数据，不执行 TS，不递归任意 JS。
- `links`：少量明确的文件到接口关系，支持不同文件名、动态请求、多接口页面；同一记录自动提供后端到页面的反向关系。

配置路径规则：`baseDirectory` 中的 `~` 先展开；相对 baseDirectory 则相对配置文件目录；每个 project.root 相对此 baseDirectory。项目内所有文件字段相对对应 project.root。项目归属按规范化后的真实文件路径匹配最深注册根，不能用字符串前缀误匹配相邻目录。多个 workspace 匹配同一路径时提示配置冲突，不悄悄选择。

### 路由与多后端

示例明确列出了 Nginx 当前六个 Node 前缀；Rust/Go 虽可本地接入，但未在此次检查的 Nginx 中发现对应转发规则，所以不虚构 `route__rust` 或 `route__go` 的现有部署配置。

未知 `route__*` 前缀保留为未解析，不去掉后强行按 PHP 查找。新增 Rust/Go 网关时，只增加 routes 项，例如实际采用 `/route__go` 后配置其 project 为 `go`。路径边界保证 `/route__node_admin2` 不会命中 `/route__node_admin`。

无前缀 URL：固定请求封装的 project > spec provider 的 project > 明确文件绑定 > backendScope 内按真实 paths 查索引。多后端命中同一路径时提示选择。示例 `fallback: "ask"` 不把所有未分流请求都默认为 PHP；即便本地 Nginx 有默认 PHP 分流，也不能据此推定所有前端请求的 API baseURL 和目标环境。

`links` 只在包含该接口的索引中生效；同一文件的多接口绑定不能根据页面名挑第一个。已识别的请求有明确网关项目时，与冲突 links 配置报错，不用 links 覆盖显式请求的路由事实。

### Vue 中的静态与动态调用

1. `common.do_ajax_async('/route__node_admin/llm_admin/manage/submit', ...)`：识别调用及字面量，经 gateway 选 Node，再查索引。
2. `partnerRequest('/partner/data/user_list', ...)`：通过请求封装配置直接选 Node；无须在业务文件上添加注释。
3. `spec: notify_task_crud_spec`：跟踪导入的特定符号，读取其 `urls.list/urls.opt`，得到 PHP 的 task_list 与 task_opt；在符号上跳转时列出两者。
4. `` `/route__node_admin${url}` ``、`props.spec.urls.opt` 等不能静态求值的表达式：只接受本文件有效 links 或提示选择接口，不进行运行时求值，不声称能自动推导所有调用链。
5. 页面有多个接口且光标不在某个请求上时，列出当前文件候选。后端到页面的关系来自 links 和已识别请求/spec 的反向索引；不假定 action 等于页面文件名。

前端索引首次可通过异步 `rg --files` 只枚举 sourceRoots 和明确的 spec/import 来源，排除 node_modules、dist、.git、测试文件；解析结果按文件修改时间缓存，保存时失效。当前未保存 buffer 的内容优先于磁盘；外部修改按 mtime 重建相关条目。不要在每次按键时同步扫描整个仓库。

### 新项目如何接入

同语言、同协议生成链路：在 projects 中加 ID、root、adapter、generatorConfig、endpointIndex，并加入前端 backendScope；如有网关再加 routes，特殊页面再加 links。无需修改主命令或复制语言代码。

不同目录但同生成链路：修改该项目 generator.toml 的 source/controllers，由生成器导出实际路径，跳转配置不再重复这些目录。

非 proto 项目：可由项目工具产生同格式 navigation.json，或通过后续显式 endpoints 配置扩展；不要假定所有后续项目都有 proto。新语言才需要新增语言适配器；新增请求封装只新增 requests 描述。配置的新增字段需随 version/schema 演进，遇到未知 adapter/provider 应校验报错。

## 6. 模块与实施顺序

建议新增模块：

```text
xcwen-project-jump.el           公共命令、context/candidate 数据、交互与执行
xcwen-project-jump-config.el    JSON schema 校验、项目图、路径规范化
xcwen-project-jump-index.el     navigation.json、前端反向关系、缓存
xcwen-project-jump-adapters.el  PHP/TS/Vue/Rust/Go 的上下文与符号定位
tests/xcwen-project-jump-tests.el
```

已完成生成器索引、四后端 Controller ↔ proto、Vue 字面量请求/泛型调用/相对导入、封装配置、CRUD spec、links、反向索引、诊断与新快捷键。旧跳转实现及 TS 旧辅助调用链已删除。前端通过异步 rg 枚举和空闲分批扫描建立关系，源文件、导入 spec 和后端索引变更均会使相关缓存失效。

### 本机加载与使用

重启 Emacs 即加载新绑定。当前会话若需要立即应用，可在 `M-:` 执行：

```elisp
(progn
  (load-file "/Users/jim/spacemacs-config/my-config.el")
  (set-main-key)
  (xcwen-jump-reload))
```

- `,a` / `,A` / `C-u ,a`：按第 2 节的新语义跳转。
- `M-x xref-go-back`：回到来源位置。
- `M-x xcwen-jump-reload`：修改配置后重新加载并后台扫描。
- `M-x xcwen-jump-describe-context`：查看项目、候选、扫描进度和未解析表达式。

当前方法声明扫描覆盖四项目全部 994 个接口。复杂的动态 URL、运行时 spec、跨文件计算表达式不执行求值，应添加 links。后台反向扫描尚未完成时，Controller 可先使用已配置 links，否则跳 proto；扫描完成后自动可选已发现页面。索引仅保存在 Emacs 内存中。

### 本机生成器安装

新生成器源码在 `~/proto-gen`，本机开发副本安装在 `~/.local/bin/proto-gen-navigation`（程序和 protoc / Go 插件在 `~/.local/lib/proto-gen-navigation/`）。此为当前源码构建，版本字符串仍是仓库的 0.4.2，并非已发布的新 Release。没有改动四项目的 Release 固定版本，也没有修改全局 shell 环境。

在任意后端根目录，用已安装的新版工具更新索引：

```sh
~/.local/bin/proto-gen-navigation generate --config proto/generator.toml
~/.local/bin/proto-gen-navigation generate --config proto/generator.toml --check
```

也可以在确认项目脚本行为后通过现有 `PROTO_GEN_BIN` 显式指定此二进制。部分项目的 gen_proto.sh 包含服务重启动作，本次验证直接调用生成器，没有执行这些脚本。后续应发布包含此功能的正式 proto-gen，再更新各项目的固定版本；旧 Release 不认识 navigation.json，不应用它重生成本次新清单。

## 7. 验收场景

以下是验收标准；自动化测试覆盖语言上下文、路由边界、多后端、导入别名/相对路径/泛型调用、spec 依赖缓存、SFC、嵌套函数、缺失目标及 xref 返回。

| 场景 | 期望 |
| --- | --- |
| PHP Notify.php::task_list | `,a` 到绑定 task_list.vue，`,A` 到 admin/notify__task_list.proto |
| Node partner/data.ts::user_list | `,A` 到 partner/data__user_list.proto |
| LlmSubmit.vue 请求字面量 | 到 Node llm_admin/manage.ts::submit |
| task_list.vue 的 spec 符号 | 列出 PHP task_list / task_opt，不要求同名 TS |
| Rust root/test.rs::user_list | 到本仓库 root/test__user_list.proto；反向定位 Test::user_list |
| Go root/test.go::UserList | 到本仓库 root/test__user_list.proto；反向定位 TestController.UserList |
| Go/Rust 的 iot_admin/media__recording_list.proto | 各自回本仓库 Controller；存在同名 PHP 接口也不抢占 |
| 无前缀、多个后端同接口 | 明确选择项目；按一次不会静默选 PHP |
| 源文件未保存 | 识别 buffer 内新请求和方法；不自动保存 |
| 方法前后、注释/字符串、辅助函数 | 不跳前一个 action、不误识别注释或嵌套函数 |
| 空格路径、~、软链接、嵌套仓库、无 .env | 按注册项目根解析；不调用 shell 拼接路径 |
| 无文件 buffer、缺配置/索引/方法、索引过期 | 可读错误/提示，不建文件、不跑生成器、不出 search-failed |
| 不同 HTTP method、短路径别名、未知 route 前缀 | 真实索引约束解析，多候选选择，未知前缀不猜 |
| 成功跳转后返回 | xref 返回原 buffer 和精确位置 |

验证命令：

```sh
# 共享生成器：44 项测试，包含 navigation 的四目标映射与只读检查/增量修复
cd ~/proto-gen
cargo test --locked --tests

# Emacs：16 项跳转回归、2 项本地集成验收、26 项原配置回归
cd ~/spacemacs-config
emacs --batch -Q -L . -l tests/xcwen-project-jump-tests.el -f ert-run-tests-batch-and-exit
emacs --batch -Q -L . -l tests/xcwen-project-jump-integration-tests.el -f ert-run-tests-batch-and-exit
emacs --batch -Q -l tests/my-config-tests.el -f ert-run-tests-batch-and-exit
```

本地集成验收逐个检查四后端的 proto 与 Controller 符号，并验证真实 Vue 的通知 spec、Node 提交和 Partner 封装调用。四后端新版 `generate --check` 已通过。原配置测试通过，但环境存在原有 symon autoload 缺失提示。
