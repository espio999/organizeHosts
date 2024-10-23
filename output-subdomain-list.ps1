# 1行に複数記録されているサブドメインを、1行ごとの記録に書き換える

$inputFile = "record.csv" 
$outputFile = "subdomain-list.txt"

# 出力ファイルが既に存在する場合は削除
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# ファイルの各行を処理
Get-Content $inputFile | ForEach-Object {
    # 現在行を取得
    $line = $_
    
    # カンマで現在行をレコードごとに分割
    $parts = $line.Trim().Split(',')

    # 1行、1レコードで記録
    $parts | ForEach-Object {
        $item = $_

        if ($item.Length -eq 0){}
        else{
          Write-Output $item
          Add-Content -Path $outputFile -Value $item
        }
    }
}
