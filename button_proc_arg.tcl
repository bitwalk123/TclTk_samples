#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"
# -----------------------------------------------------------------------------
#  ボタンウィジェットをクリックして手続きDispKeyTopを実行、クリックしたボタン名
#  を引数として渡す
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# DispKeyTop
# ベルをならして、押したボタン名をコンソール上に表示する。
# 引数
#   key: コンソール上に表示する文字列（ボタン名）
# -----------------------------------------------------------------------------
proc DispKeyTop {key} {
    # ベルをならす
    bell
    # コンソール上に結果を表示する。
    puts "ボタン「${key}」が押されました。"
    return
}
# -----------------------------------------------------------------------------
#  メイン
# -----------------------------------------------------------------------------
# Windows版、Mac版ではコンソールを表示
switch $tcl_platform(platform) {
    windows -
    macintosh {
        console show
    }
}
set key_list {い ろ は に ほ へ と ち り}
# ボタンウィジェットの定義
for {set i 0} {$i < 9} {incr i} {
    set key_top [lindex $key_list $i]
    button .but$i -text $key_top -command "DispKeyTop $key_top"
    # gridで配置
    set r [expr $i/3]
    set c [expr $i%3]
    grid .but$i -row $r -column $c -ipadx 5 -ipady 5 -sticky news
}
# ---
# button_proc_arg.tcl
