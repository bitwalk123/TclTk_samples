#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"
# -----------------------------------------------------------------------------
#  シンプルなボタンウィジェット
# -----------------------------------------------------------------------------
# ボタンウィジェット.butの定義
button .but -text "押して♪" -command {bell}
# packで配置
pack .but
# ---
# button_simple.tcl