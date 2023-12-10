#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"
# -----------------------------------------------------------------------------
#  ボタンウィジェットの-defaultオプションによる見栄えの違い
# -----------------------------------------------------------------------------
set w 0
set h 0
set bw 2
# ボタンウィジェットの定義
set default_list {
    normal active disabled
}
foreach state $default_list {
    frame .f_$state -background white -borderwidth $bw -relief ridge
    set y [expr [lsearch $default_list $state]/3.]
    place .f_$state -relx 0 -rely $y -relwidth 1 -relheight [expr 1./3.] 
    button .but_$state -text "テストボタン\n(${state})" \
            -borderwidth 5 -highlightbackground yellow  \
            -highlightcolor orange -highlightthickness 10 \
            -default $state
    # placeで配置
    place .but_$state -in .f_$state -relx 0.5 -rely 0.5 -anchor c
    update
    set w0 [winfo width  .but_$state]
    set h0 [winfo height .but_$state]
    if {$w0 > $w} {
        set w $w0
    }
    if {$h0 > $h} {
        set h $h0
    }
}
set w [expr $w + 2*$bw + 10]
set h [expr $h + 2*$bw + 10]
foreach state $default_list {
    .f_$state configure -width $w -height $h
}
. config -width $w -height [expr $h*3]
# ---
# button_default.tcl
