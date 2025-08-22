Import-Module GenXdev.Webbrowser

# Ánh xạ tag → URL
$tagToUrl = @{
    'Notifications' = 'https://my.phillip-sec-online.jp/manage/notifications'
    'Upload'        = 'https://reg.phillip-sec-online.jp/upload/'
    'Regist'        = 'https://reg.phillip-sec-online.jp/regist'
    'RegistB2B'     = 'https://reg.phillip-sec-online.jp/regist-b2b'
}

function Refresh-ByTag {
    param(
        [Parameter(Mandatory)][string]$Tag
    )

    if (-not $tagToUrl.ContainsKey($Tag)) {
        Write-Warning "Không tìm thấy tag '$Tag'"
        return
    }

    $url = $tagToUrl[$Tag]

    # Chọn tab Chrome chứa URL này
    Select-WebbrowserTab -Name $url -Chrome

    # Thực thi JS để reload trang
    Invoke-WebbrowserEvaluation "window.location.reload();" -NoAutoSelectTab
    Write-Host "Đã refresh tab: $Tag ($url)"
}

# Ví dụ gọi:
foreach ($tag in $tagToUrl.Keys) {
    Refresh-ByTag -Tag $tag
    Start-Sleep -Seconds 2
}





# function Refresh-Browser {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string[]]$Titles,
#         [int]$DelayMs = 500
#     )
#     $shell = New-Object -ComObject WScript.Shell

#     foreach ($title in $Titles) {
#         if ($shell.AppActivate($title)) {
#             Start-Sleep -Milliseconds $DelayMs
#             $shell.SendKeys('{F5}')
#             Write‑Host "Làm mới: $title"
#         } else {
#             Write‑Host "Không kích hoạt được cửa sổ:" $title -ForegroundColor Yellow
#         }
#     }
# }

# $titlesToRefresh = @(
#     'TDT Collabia - Google Chrome',
#     'Zimbra: Inbox (19) - Google Chrome',
#     'TĐT - Google Chrome',
#     'My account - CQ TDT Asia - Google Chrome'
# )

# # Vòng lặp làm mới các cửa sổ theo thứ tự cứ mỗi 10 giây, rồi mỗi 120 giây lặp lại
# while ($true) {
#     Refresh-Browser -Titles $titlesToRefresh -DelayMs 500
#     Start-Sleep -Seconds 120
# }






# function Refresh-Browser {
#     $shell = New-Object -ComObject WScript.Shell
#     $shell.AppActivate('TDT Collabia - Google Chrome')  # Hoặc tên cửa sổ cụ thể
#     Start-Sleep -Milliseconds 500
#     $shell.SendKeys('{F5}')
# }

# function Refresh-Browser {
#     $shell = New-Object -ComObject WScript.Shell
#     $shell.AppActivate('Zimbra: Inbox (19) - Google Chrome')  # Hoặc tên cửa sổ cụ thể
#     Start-Sleep -Milliseconds 500
#     $shell.SendKeys('{F5}')
# }

# function Refresh-Browser {
#     $shell = New-Object -ComObject WScript.Shell
#     $shell.AppActivate('TĐT - Google Chrome')  # Hoặc tên cửa sổ cụ thể
#     Start-Sleep -Milliseconds 500
#     $shell.SendKeys('{F5}')
# }

# function Refresh-Browser {
#     $shell = New-Object -ComObject WScript.Shell
#     $shell.AppActivate('My account - CQ TDT Asia - Google Chrome')  # Hoặc tên cửa sổ cụ thể
#     Start-Sleep -Milliseconds 500
#     $shell.SendKeys('{F5}')
# }

# while ($true) {
#     Refresh-Browser
#     Start-Sleep -Seconds 10
# }

# # Khởi tạo đối tượng COM WScript.Shell
# $shell = New-Object -ComObject WScript.Shell

# # Danh sách các tiêu đề cửa sổ Chrome cần làm mới
# $titles = @(
#     'Google - Chrome - TDT Collabia',
#     'Google - Chrome - TĐT',
#     'Google - Chrome - My account',
#     'Google - Chrome - Zimbra'
# )

# # Lặp qua từng tiêu đề và thực hiện thao tác
# foreach ($title in $titles) {
#     # Kích hoạt cửa sổ theo tiêu đề
#     $shell.AppActivate($title)

#     # Đợi một chút để đảm bảo cửa sổ được kích hoạt
#     Start-Sleep -Milliseconds 500

#     # Gửi phím F5 để làm mới trang
#     $shell.SendKeys('{F5}')

#     # Đợi 2 phút trước khi làm mới cửa sổ tiếp theo
#     Start-Sleep -Seconds 2
# }
