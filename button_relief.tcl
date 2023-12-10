#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"
# -----------------------------------------------------------------------------
#  ボタンウィジェットでレリーフの種類を表示
# -----------------------------------------------------------------------------
# レリーフ
set relief_list {
    flat groove raised ridge solid sunken
}
# レリーフ毎のボタンを定義
foreach relief_name $relief_list {
    button .but$relief_name -text $relief_name \
            -foreground white -background lightblue \
            -relief $relief_name -borderwidth 10 \
            -padx 5 -pady 5 \
            -font "courier 14 bold"
    pack .but$relief_name -fill both -padx 5 -pady 5
}
# ---
# button_relief.tcl
