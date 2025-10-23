#Requires AutoHotkey v2.0

Sleep 1000
Send "^#{Right}"

Sleep 1000
CoordMode "Mouse", "Screen"
MouseClick "left", 815, -602

Sleep 1000
CoordMode "Mouse", "Screen"
MouseClick "left", 1635, -602

Sleep 5000
Send "{F1}"

Sleep 1000
CoordMode "Mouse", "Screen"
MouseClick("left", 293, -1016, 1, 0, "D")

Sleep 1000
CoordMode "Mouse", "Screen"
MouseClick("left", 1883, -276, 1, 0, "U")

Sleep 1000
Send "^c"

Sleep 1000
Send "^#{Left}"

;Sleep 1000 ; chọn windown
;CoordMode "Mouse", "Screen"
;MouseClick "left", 121, 1058

Sleep 1000 ; chọn tab
CoordMode "Mouse", "Screen"
MouseClick "left", 1008, 11

Sleep 1000 ; chọn group
CoordMode "Mouse", "Screen"
MouseClick "left", 1152, 461

Sleep 1000 ; chọn message
CoordMode "Mouse", "Screen"
MouseClick "left", 1464, 1000

Sleep 1000
Send "^v"

Sleep 500
Send "Dear all, OM team report:+{Enter}- Price on mobile and web iss normal.+{Enter}Kindly be infformed!"

Sleep 1000
Send "{Enter}"

