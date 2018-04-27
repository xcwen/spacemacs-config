# 异步表格
## control
```php
    public function async_table() {
        //queryParams
        $builder= new \App\Core\Query\SqlBuilder($this->t_student_info->as("s") );
        $field_config= new \App\Core\Query\FieldConfig ();
        //$field_config->set_field_info("regs_time",  "reg_time");
        //order by 配置
        $field_config->set_field_info("grade_str",  $this->t_student_info, "grade");
        //userid 设置时, 其它的忽略
        $field_config->set_first_deal_flag("userid");

        $builder->select("userid" , "nick", "phone","grade", "s.reg_time", "s.user_agent" );

        $ret_info= $builder->get_list_by_page($field_config);
        foreach ($ret_info["list"] as &$item ) {
            \App\Helper\Utils::unixtime2date_for_item($item, "reg_time");
            E\Egrade::set_item_value_str($item);
        }
        return $this->output_succ($ret_info);
    }
```

##  view 
```html
@extends('layouts.app')
@section('content')

    <script type="text/javascript" src="/page_ts/lib/admin_new_query.js"></script>

    <section class="content ">

        <div id="id_header_query_info" >
        </div>


        <hr/>

        <div id="id_async_table_toolbar" >
            <button class="btn btn-primary" id="id_test" > select </button>
        </div>


        <table id="id_async_table"   >
        </table>
        <div style="display:none;" id="id_async_table_option"  >
            <a class="btn fa fa-edit opt-edit" title="edit info">edit  </a>
            <a class="btn fa fa-times" title="delete"> </a>
            <a class="btn fa fa-times" title="delete"> </a>
            <a class="btn fa fa-times" title="delete"> </a>
            <a class="btn fa fa-times" title="delete"> </a>
        </div>



    </section>

@endsection
```


##  js 
```js
/// <reference path="../common.d.ts" />
/// <reference path="../g_args.d.ts/self_manage-test.d.ts" />



$(function() {
    var $header_query_info = $("#id_header_query_info").admin_header_query({
        query: function(args) {
            $id_async_table.bootstrapTable("refresh", {
                url: window.location.pathname,
            });
        }
    });

    $.admin_query_input({
        "join_header": $header_query_info,
        "field_name": "query_text",
        "title": "学生姓名",
        "placeholder": "学生姓名",
        "select_value": g_args.query_text,
    });

    var start_time = new Date();
    start_time.setMonth(start_time.getMonth() + 1);
    $.admin_date_select({
        "join_header": $header_query_info,
        "title": "时间",
        'date_type': $.get_in_str_val(g_args.date_type, "reg_time"),
        'opt_date_type': $.get_in_int_val(g_args.opt_date_type, 2),
        //'start_time': g_args.start_time,
        'end_time': g_args.end_time,

        'start_time': $.get_in_str_val(g_args.start_time, $.DateFormat(start_time)),
        "date_type_config": {
            "reg_time": "xxxx time",
            "eg_time": "22time",
        }
    });



    $.admin_enum_select({
        "join_header": $header_query_info,
        "enum_type": "grade",
        "field_name": "grade",
        "title": "年级",
        "select_value": g_args.grade,
    });

    $.admin_enum_select({
        "join_header": $header_query_info,
        "enum_type": "subject",
        "title": "科目",
        "select_value": g_args.subject,
        "id_list": [1, 2, 3, 4, 5, 6],
    });

    $.admin_enum_select({
        "join_header": $header_query_info,
        "enum_type": null,
        "field_name": "contract_type",
        "option_map": {
            1: "xx",
            2: "kkk 2 ",
            3: "nnn3  ",
        },
        "title": "合同类型",
        "select_value": g_args.contract_type,
    });

    $.admin_ajax_select_user({
        "join_header": $header_query_info,
        "field_name": "userid",
        "title": "学生",
        "length_css": "col-xs-6 col-md-2",
        "as_header_query": false,
        "user_type": "student",
        "select_value": g_args.userid,
        "th_input_id": null,
        "can_select_all_flag": true
    });

    var $id_async_table = $("#id_async_table");

    $id_async_table.async_table({
        header_query_info: $header_query_info,
        bind_row_btn_event: bind_row_btn_event,
        columns: [{
            checkbox: true,
        }, {
            title: "xx",
            field: "userid",
        }, {
            title: "xxnick",
            field: "nick",
        }, {
            title: "phone",
            field: "phone",
            sortable: true,
            default_hide_in_phone: true,
        }, {
            title: "年级",
            field: "grade_str",
            sortable: true,
            /*
            field: "grade",
            sortable: true,
            formatter: function(val, row, $index) {
                return row["grade_str"];
            }
            */


        }, {
            title: "注册时间",
            field: "reg_time",

        }, {
            title: "user_agent",
            field: "user_agent",
        }],
    });

    function bind_row_btn_event() {
        $(".opt-edit").on("click", function() {
            var opt_data = $(this).get_opt_data();
            console.log(opt_data);
            alert("xx");
        });

    };



    $("#id_test").on("click", function() {
        var data = $id_async_table.bootstrapTable("getSelections");
        console.log(data);

    });


    $header_query_info.query();

})

```
