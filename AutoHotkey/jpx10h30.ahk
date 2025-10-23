#Requires AutoHotkey v2.0

Sleep 1000 ; chọn tab
CoordMode "Mouse", "Screen"
MouseClick "left", 1008, 11

Sleep 1000 ; chọn group
CoordMode "Mouse", "Screen"
MouseClick "left", 1162, 410

Sleep 1000
CoordMode "Mouse", "Screen"
MouseClick "left", 1424, 994

Sleep 500
Send "Dear all, OM team report:+{Enter}- JPX's lunch break iss over.+{Enter}Kindly be infformed!"

Sleep 1000
Send "{Enter}"

