#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"
# -----------------------------------------------------------------------------
#  ボタンウィジェットにビットマップを表示
# -----------------------------------------------------------------------------
# ビルトイン・ビットマップ
label .l1 -text "ビルトイン・ビットマップ" -relief ridge
pack .l1 -fill x
frame .base
pack .base -fill both -expand yes
#
set builtin_bitmap {
    error     gray12 gray25    gray50   gray75
    hourglass info   questhead question warning
}
set rowweight ""
set colweight ""
set n 0
foreach bname $builtin_bitmap {
    set b ".b_${bname}"
    set l ".l_${bname}"
    button $b -bitmap $bname -width 100 -height 32 \
	    -foreground blue -background white -activeforeground red
    label $l -text $bname
    set r1 [expr $n / 4 * 2]
    set r2 [expr $r1 + 1]
    set c [expr $n % 4]
    grid $b -in .base -row $r1 -column $c -sticky news
    grid $l -in .base -row $r2 -column $c

    lappend rowweight $r1
    lappend colweight $c
    incr n
}
grid rowconfigure    .base $rowweight -weight 1
grid columnconfigure .base $colweight -weight 1

# ユーザ定義ビットマップ
set tk_icon {
    #define tk_width 32
    #define tk_height 32
    static unsigned char tk_bits[] = {
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0xfc, 0x03, 0x00, 0x80, 0xff, 0x07, 0x0c, 0xe0, 0xff, 0x07, 0x0e,
      0xf0, 0xff, 0x0f, 0x0f, 0xf0, 0x07, 0x86, 0x07, 0x78, 0x00, 0xc7, 0x03,
      0x78, 0x00, 0xe3, 0x01, 0xc0, 0x80, 0xe1, 0x00, 0x00, 0xc0, 0xf1, 0x00,
      0x00, 0xe0, 0x78, 0x0e, 0x00, 0x60, 0xb8, 0x0f, 0x00, 0x70, 0xdc, 0x0f,
      0x00, 0x38, 0x6c, 0x07, 0x00, 0x38, 0xb6, 0x03, 0x00, 0x1c, 0xfe, 0x0d,
      0x00, 0x1c, 0xfe, 0x0c, 0x00, 0x1e, 0xfe, 0x07, 0x00, 0x0e, 0xe6, 0x03,
      0x00, 0x0e, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    };
}
label .l2 -text "ユーザ定義ビットマップ（イメージ）" -relief ridge
pack .l2 -fill x
# イメージの定義
image create bitmap Tk -data $tk_icon -foreground red
# ビットマップファイルを使う場合は -bitmap "@fileName" オプションを使用する。
# この場合はビルトイン・ビットマップと同様に
# -foregroundと-activeforegroundのオプションが有効になる。
button .b_bitmap -image Tk -background white
pack .b_bitmap -expand yes -fill both
# ---
# button_bitmap.tcl
