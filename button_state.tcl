#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"
# -----------------------------------------------------------------------------
#  ボタンウィジェットで-stateオプションによる違いを表示
# -----------------------------------------------------------------------------
# ボタンウィジェットの定義
set state_list {
    normal active disabled
}
foreach state $state_list {
    button .but_$state -text "テストボタン\n(${state})" \
            -background cyan -foreground blue \
            -activebackground orange -activeforeground red \
            -disabledforeground white \
            -state $state
    # packで配置
    pack .but_$state
}
# ---
# button_state.tcl
