$ErrorActionPreference = "Stop"

$targetPath = Join-Path $PSScriptRoot "manage_submit_edge_profiles.ps1"
if (-not (Test-Path -LiteralPath $targetPath)) {
    throw "Không tìm thấy manage_submit_edge_profiles.ps1"
}

$content = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8
$original = $content

$content = $content.Replace(
    '$deleteExternalUrlButton.Text = "XÓA NHANH TOÀN BỘ URL"',
    '$deleteExternalUrlButton.Text = "XÓA TOÀN BỘ URL"'
)

$oldLayout = @'
    $autoSubmitButton.Location = [System.Drawing.Point]::new(24, $buttonY)
    $stopAutoButton.Location = [System.Drawing.Point]::new(194, $buttonY)
    $stopNowButton.Location = [System.Drawing.Point]::new(372, $buttonY)
    $addUrlsButton.Location = [System.Drawing.Point]::new(500, $buttonY)
    $openUrlListButton.Location = [System.Drawing.Point]::new(668, $buttonY)
    $deleteExternalUrlButton.Location = [System.Drawing.Point]::new(668, $buttonY - 40)
    $deleteExternalUrlButton.Anchor = "Bottom,Right"
'@

$newLayout = @'
    # Sáu nút thao tác nằm cùng một hàng, tự co giãn theo chiều rộng cửa sổ.
    [int]$actionGap = 10
    [int]$actionAvailableWidth = $panelWidth - 48
    [int]$actionButtonWidth = [math]::Floor(
        ($actionAvailableWidth - ($actionGap * 5)) / 6
    )
    if ($actionButtonWidth -lt 110) { $actionButtonWidth = 110 }

    $actionButtons = @(
        $autoSubmitButton,
        $stopAutoButton,
        $stopNowButton,
        $addUrlsButton,
        $openUrlListButton,
        $deleteExternalUrlButton
    )
    for ($actionIndex = 0; $actionIndex -lt $actionButtons.Count; $actionIndex++) {
        [int]$actionX = 24 + ($actionIndex * ($actionButtonWidth + $actionGap))
        $actionButtons[$actionIndex].Location = [System.Drawing.Point]::new(
            $actionX,
            $buttonY
        )
        $actionButtons[$actionIndex].Size = [System.Drawing.Size]::new(
            $actionButtonWidth,
            34
        )
        $actionButtons[$actionIndex].Anchor = "Bottom,Left"
    }
'@

if ($content.Contains($oldLayout)) {
    $content = $content.Replace($oldLayout, $newLayout)
} elseif (-not $content.Contains('$actionButtons = @(')) {
    throw "Không tìm thấy khối bố cục nút cũ để cập nhật."
}

if ($content -ne $original) {
    Copy-Item -LiteralPath $targetPath -Destination "$targetPath.layout.bak" -Force
    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($targetPath, $content, $utf8)
}
