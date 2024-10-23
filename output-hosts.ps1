# サブドメイン一覧をもとに、hostsファイルを出力する。

$inputFile = "subdomain-list.txt"
$outputFile = "hosts.txt"
$address = "0.0.0.0"

# 出力ファイルが既に存在する場合は削除
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# ファイルの各行を処理
Get-Content $inputFile | ForEach-Object {
    # 現在の行を取得
    $line = $_
    $output = "$address $line"
    
    Write-Output $output
    Add-Content -Path $outputFile -Value $output
}
