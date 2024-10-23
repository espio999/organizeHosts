# サブドメインからドメイン名を取り出す。
# ドメイン名の一覧を出力する。　

# 出力ファイルが既に存在する場合は削除

$inputFile = "subdomain-list.txt"
$outputFile = "domain-list.txt"

if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# ファイルの各行を処理
Get-Content $inputFile | ForEach-Object {
    # 現在の行を取得
    $line = $_
    
    # ドットで文字列を分割
    $parts = $line.Split('.')
    
    # 部分が2つ以上ある場合のみ処理
    if ($parts.Count -ge 2) {
        # 最後の部分と、その直前の部分を取得
        $lastPart = $parts[-1]
        $secondLastPart = $parts[-2]
        
        # co.jp, ne.jp, or.jpの場合は3つ目の部分も取得
        if (
          $lastPart -eq "jp" -and
          ($secondLastPart -eq "co") -or ($secondLastPart -eq "or") -or ($secondLastPart -eq "ne") -and 
          $parts.Count -ge 3) {
            $thirdLastPart = $parts[-3]
            $output = "$thirdLastPart.$secondLastPart.$lastPart"
        }
        else {
            # 通常のケース
            $output = "$secondLastPart.$lastPart"
        }
    }

    Write-Output $output
    Add-Content -Path $outputFile -Value $output
}
