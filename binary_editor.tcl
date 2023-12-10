#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"
# -----------------------------------------------------------------------------
#  LoadFile
#  バイナリ文書の読み込み
#  引数
#    widget: 読み込み先のテキストウィジェットのパス名
#    types:  ファイルの拡張子のリスト
# -----------------------------------------------------------------------------
proc LoadFile {widget types} {
    set fileName [tk_getOpenFile -title "文書読込" -filetypes $types -parent .]
    if {$fileName == ""} {
        return
    } elseif {![file readable $fileName]} {
	return
    } else {
	$widget delete 1.0 end
	set fileId [open $fileName "r"]
	# 行末文字を変換しない、またエンコードも設定しない。
	fconfigure $fileId -translation binary -encoding binary
	# 一行に表示するバイト数
	set bytes 16
	set row 1
	# 表示上の１行単位($bytes)で読み込む
	while {![eof $fileId]} {
	    set contents [read $fileId $bytes]
	    set dlength  [string length $contents]
	    # 一行を個々のデータを区切って１６進数表示にする
	    set data ""
	    for {set i 0} {$i < $dlength} {incr i} {
		# 文字コードに変換
		binary scan $contents "@${i}c1" var
		# 128以上は-128, -127, -126になるので正数にする
		if {$var < 0} {
		    set var [expr 256 + $var]
		}
		# １６進数表示にフォーマット、アルファベットは大文字で
		lappend data [string toupper [format "%2.2x" $var]]
	    }
	    # 一行単位でテキストウィジェットへ表示
	    $widget insert $row.0 "$data\n"
	    incr row
	}
	close $fileId
	return
    }
}
# -----------------------------------------------------------------------------
#  SaveFile
#  バイナリ文書の保存
#  引数
#    widget: 保存する内容があるテキストウィジェットのパス名
#    types:  ファイルの拡張子のリスト
# -----------------------------------------------------------------------------
proc SaveFile {widget types} {
    set fileName [tk_getSaveFile -title "文書保存" -filetypes $types \
	    -parent . -defaultextension .txt -initialfile Untitled]
    if {$fileName == ""} {
        return
    } else {
	set contents [$widget get 1.0 end]
	set data ""
	# リストの要素を一つづつ取り出し0xを付けてバイナリ変換
	foreach hex $contents {
	    set hexdata "0x$hex"
	    append data [binary format c1 $hexdata]
	}
	set fileId [open $fileName "w"]
	# 行末文字を変換しない、またエンコードも設定しない。
	fconfigure $fileId -translation binary -encoding binary
	puts -nonewline $fileId $data
	close $fileId
	return
    }
}
# -----------------------------------------------------------------------------
#  メイン
# -----------------------------------------------------------------------------
# ウィンドウのタイトルを定義
wm title . "簡易バイナリエディタ"
# UNIX版の場合、フォントの設定と、XIMを有効にする
if {$tcl_platform(platform) == "unix"} {
	option add *font k14
	tk useinputmethods 1
}
# 読み書きするファイルの拡張子のリスト
set fileTypes {
    {"All files"    *}
}
# メニューバーを定義
set mbar .menubar
. configure -menu $mbar
menu $mbar
$mbar add cascade -label "ファイル(F)"  -underline 5 -menu $mbar.file
$mbar add cascade -label "編集(E)"      -underline 3 -menu $mbar.edit
#
set menu1 $mbar.file
menu $menu1 -tearoff no
$menu1 add command -label "開く(O)"     -underline 3 \
	-command {LoadFile .txt $fileTypes}
$menu1 add command -label "保存(S)"     -underline 3 \
	-command {SaveFile .txt $fileTypes}
$menu1 add separator
$menu1 add command -label "終了(X)"     -underline 3 -command {exit}
#
set menu2 $mbar.edit
menu $menu2 -tearoff no
$menu2 add command -label "カット(T)"   -underline 4 -accelerator "Ctrl-X"
$menu2 add command -label "コピー(C)"   -underline 4 -accelerator "Ctrl-C"
$menu2 add command -label "ペースト(P)" -underline 5 -accelerator "Ctrl-V"
# テキストウィジェットを定義
text .txt -width 48 -height 24 \
	-background white \
	-font {courier 14 normal} \
	-yscrollcommand {.scrl set}
# 垂直方向のスクロールバーを定義
scrollbar .scrl -command {.txt yview}
#
grid .txt  -row 0 -column 0 -sticky news
grid .scrl -row 0 -column 1 -sticky ns
grid columnconfigure . 0 -weight 1
grid rowconfigure    . 0 -weight 1
# ---
# binary_editor.tcl
