#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"
# -----------------------------------------------------------------------------
#  キーボードトラバーサルの確認）
# -----------------------------------------------------------------------------
set key_list {
    い ろ は に ほ へ と ち り
}
# ボタンウィジェットの定義
for {set i 0} {$i < 9} {incr i} {
    set key_top [lindex $key_list $i]
    button .but$i -text $key_top -padx 10 -pady 10 \
            -highlightthickness 5 \
            -highlightcolor red -highlightbackground yellow \
            -takefocus 1
    # gridで配置
    set r [expr $i/3]
    set c [expr $i%3]
    grid .but$i -row $r -column $c -sticky news
}
# ---
# button_takefocus.tcl
