#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"
# -----------------------------------------------------------------------------
#  DoAppend
#  数字を追加
#  引数
#    what
# -----------------------------------------------------------------------------
proc DoAppend {what} {
    global state
    # 数字入力のはじめであれば、まず表示を「0.」にする。
    if {$state(started) == 0} {
        set state(ent) 0.
        set state(started) 1
    }
    # 演算子を前に入力していなければ結果を「0.」にする。
    if {$state(op) == ""} {
        set state(result) 0.
    }
    # 入力は１２桁までとする。
    if {[string length $state(ent)] > 12} return
    # 入力処理
    if {!($what == 0 && [string compare $state(ent) 0.] == 0)} {
        # 「0」でない数字の入力、または表示が「0.」でない場合
        if {$state(dot) == 1} {
            # 小数を含む数の場合
            set state(ent) [format "%s%s" $state(ent) $what]
            return
        } else {
            # 整数の場合
            regexp {([-0-9]+).} $state(ent) foo integer
            if {$integer == 0} {
                # 整数０の場合
                set state(ent) [format "%s." $what]
                return
            } else {
                # ０以外の整数の場合
                set state(ent) [format "%s%s." $integer $what]
                return
            }
        }
    } else {
        # 「0」の入力の時で、かつ表示が「0.」の場合
        if {$state(dot) == 1} {
            # 小数点がすでに入力されている場合
            set state(ent) 0.0
            return
        }
        # 小数点が入力されていない場合は何もしない。
        return
    }
}
# -----------------------------------------------------------------------------
#  DoClear
#  消去
# -----------------------------------------------------------------------------
proc DoClear {} {
    global state
    set state(ent) 0.
    set state(dot) 0
    if {$state(started) == 0} {
        set state(result) 0.
        set state(op) ""
    }
    set state(started) 0
    return
}
# -----------------------------------------------------------------------------
#  DoDot
#  小数点
# -----------------------------------------------------------------------------
proc DoDot {} {
    global state
    set state(dot) 1
    return
}
# -----------------------------------------------------------------------------
#  DoEqual
#  結果
# -----------------------------------------------------------------------------
proc DoEqual {} {
    global state
    if {$state(op) != ""} {
        # 演算を含んでいる場合、計算して結果へ。
        set state(result) \
                [eval expr "$state(result) $state(op) $state(ent)"]
    } else {
        # 演算しない場合、表示をそのまま結果へ。
        set state(result) $state(ent)
    }
    # 結果の表示を「##.」の形式に整形
    if {[regexp {(.0)$} $state(result)] == 1} {
        set zero [expr [string length $state(result)] - 2]
        set state(ent) [string range $state(result) 0 $zero]
    } else {
        set state(ent) $state(result)
    }
    set state(started) 0
    set state(op) ""
    set state(dot) 0
    return
}
# -----------------------------------------------------------------------------
#  DoFunc
#  関数の評価
#  引数
#    func
# -----------------------------------------------------------------------------
proc DoFunc {func} {
    global state
    set L (
    set R )
    set state(ent) [eval expr "$func$L$state(ent)$R"]
    DoEqual
    return
}
# -----------------------------------------------------------------------------
#  DoPercent
#  百分率
# -----------------------------------------------------------------------------
proc DoPercent {} {
    global state
    set state(ent) [expr $state(ent)/100.]
    DoEqual
    return
}
# -----------------------------------------------------------------------------
#  DoOpe
#  演算
#  引数
#    what
# -----------------------------------------------------------------------------
proc DoOpe {what} {
    global state
    if {$state(op) != ""} {
        DoEqual
    }
    set state(op) $what
    set state(result) $state(ent)
    set state(started) 0
    set state(dot) 0
    return
}
# -----------------------------------------------------------------------------
#  DoSign
#  符号
# -----------------------------------------------------------------------------
proc DoSign {} {
    global state
    set state(ent) [expr -$state(ent)]
    set state(started) 0
    return
}
# -----------------------------------------------------------------------------
#  メイン
# -----------------------------------------------------------------------------
# 基本フォントのリソースを設定
switch $tcl_platform(platform) {
    unix {
        set font_name kanji16
    }
    windows {
        set font_name "{ＭＳ ゴシック} 14 normal"
    }
    default {
        set font_name "mincho"
    }
}
option add *font $font_name
# 表示ウィンドウの設定
wm title . "電卓"
wm resizable . 0 0
# 初期設定
set state(result)  0. ; # 計算結果
set state(ent)     0. ; # 表示上の数字
set state(op)      {} ; # 演算子
set state(dot)     0  ; # 小数点入力のフラグ
set state(started) 0  ; # 数字入力の開始フラグ
# 数字・演算キーの文字列と、コールする関数を定義
set keytop {
    {７ {DoAppend 7} }
    {８ {DoAppend 8} }
    {９ {DoAppend 9} }
    {÷ {DoOpe /}    }
    {Ｃ  DoClear     }
    {４ {DoAppend 4} }
    {５ {DoAppend 5} }
    {６ {DoAppend 6} }
    {× {DoOpe *}    }
    {√ {DoFunc sqrt}}
    {１ {DoAppend 1} }
    {２ {DoAppend 2} }
    {３ {DoAppend 3} }
    {－ {DoOpe -}    }
    {％  DoPercent   }
    {０ {DoAppend 0} }
    {±  DoSign      }
    {・  DoDot       }
    {＋ {DoOpe +}    }
    {＝  DoEqual     }
}
# 表示部
label .disp -textvariable state(ent) \
        -font {courier 16 normal} -fg #ffff00 -bg #004000 \
        -anchor e -relief ridge -borderwidth 4 -padx 5 -pady 5
grid .disp -row 0 -column 0 -columnspan 5 -sticky "news"
# 数字・演算キー
for {set y 1} {$y < 5} {incr y} {
    for {set x 0} {$x < 5} {incr x} {
        set idx [expr $x + ($y - 1) * 5]
        set key [lindex [lindex $keytop $idx] 0]
        set cmd [lindex [lindex $keytop $idx] 1]
        button .b$idx -text $key -padx 10 -command $cmd 
        grid .b$idx -row $y -column $x -sticky news
    }
}
# ---
# calculator.tcl
