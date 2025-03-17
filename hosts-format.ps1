# スクリプトの目的: hostsファイルを読み込み、1行に一つのアドレス、一つのドメインとなるように整形する

$parent_drive = "d:\"
$parent_folder = (Get-Date -UFormat %Y) + "\"
$daily_folder = (Get-Date -UFormat %m%d) + "\"
$hosts_file = "hosts.txt"
$outputFile = $parent_drive + $parent_folder + $daily_folder + $hosts_file

# 入力ファイル名 (hostsファイルへのパスを指定)
$inputFile = "C:\Windows\System32\drivers\etc\hosts"

# 正規表現パターン：IPアドレスとドメイン名を抽出
$pattern = '^(?<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+(?<domain>.+)$'

# 処理結果を格納する配列
$formattedLines = @()

# hostsファイルを読み込む
try {
    $lines = Get-Content -Path $inputFile -ErrorAction Stop
}
catch {
    Write-Error "hostsファイルの読み込みに失敗しました。: $_"
    exit 1
}

# 各行を処理
foreach ($line in $lines) {
    # コメント行や空白行を無視
    if ($line -match '^\s*(#.*)?$') {
        continue
    }

    # 正規表現でIPアドレスとドメイン名を抽出
    if ($line -match $pattern) {
        $ip = $Matches.ip
        $domains = $Matches.domain -split '\s+'

        # ドメインごとに1行ずつ出力
        foreach ($domain in $domains) {
          if($domain -ne ""){
            $formattedLines += "$ip $domain"
          }
        }
    } else {
        Write-Warning "書式が正しくない行をスキップしました: $line"
    }
}

# 結果を出力ファイルに書き込む
try {
    $formattedLines | Out-File -FilePath $outputFile -Encoding UTF8 -Force -ErrorAction Stop
    Write-Host "整形されたhostsファイルが '$outputFile' に出力されました。"
}
catch {
    Write-Error "出力ファイルへの書き込みに失敗しました。: $_"
    exit 1
}

#テストデータ作成用処理
#必要に応じて、以下の部分をアンコメントして実行してください。
#@"
#0.0.0.0 eb2.3lift.com ib.3lift.com
#127.0.0.1 localhost test.com
#::1 localhost
#@ | Out-File -FilePath "input_hosts.txt" -Encoding UTF8 -Force
#write-host "input_hosts.txtが作成されました"
