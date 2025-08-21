Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# Thiết lập vùng chụp
$X = 208; $Y = 46; $Width = 1343; $Height = 757
$bounds = [Drawing.Rectangle]::FromLTRB($X, $Y, $X + $Width, $Y + $Height)

# Giao diện xử lý ảnh
$bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.Size)

# Lưu file
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$savePath = "D:\ThangND\.ps1\screenshot_$timestamp.png"
$bitmap.Save($savePath, [System.Drawing.Imaging.ImageFormat]::Png)

# Giải phóng bộ nhớ
$graphics.Dispose()
$bitmap.Dispose()
