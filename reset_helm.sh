#!/bin/bash
cd ~/.emacs.d/elpa/helm-20*
rm -f *.elc
sed  -i -e  "/C-M-SPC/d" ./helm-buffers.el
sed   -i -e  "/M-RET/d" ./helm-mode.el
sed   -i -e  "/M-RET/d" ./helm-files.el
