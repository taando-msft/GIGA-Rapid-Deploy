# Rapid Deploy用にアカウントを作成するスクリプトです。

# カレントディレクトリを実際に作業する環境に合わせて変更

Set-Location -Path C:\xxxxx

# 出力パスの定義
# 既存のフォルダがあればリネーム
$output_Path = ".\output"

if (Test-Path $output_Path){
    $temp=get-date
    $temp_path = $output_Path+"_"+$temp.Ticks
    Rename-Item $output_Path -NewName $temp_path
}

New-Item $output_Path -ItemType Directory -Force

# 学校情報のCSVを読み込み
$schools = import-CSV .\schoollist.csv

# デバッグ用出力
#$schools | ft -AutoSize

# デフォルトの情報は定数化
$domainname = "@xxxxx.onmicrosoft.com"
$prefix_id="s"
$prefix_displayname="生徒"
$JobTitle="Student"
$State="東京"
$UsageLocation="JP"
$Country="Japan"

# CSVの左側の要素からの順次処理

# 生徒はすべて通し番号
$serial = 1

foreach ($proc in $schools){
    
    # 定数の定義と出力用のカスタムオブジェクトの作成＆初期化

    # CSVから学校名,人数を読み込み

    $schoolname=$proc.学校名
    $students=$proc.人数

    # 学校毎の出力するファイル名を設定

    $filename=$output_Path+"\"+$schoolname+".csv"

    $filename

    # 学校毎に配列を初期化
    $DATAs = @()
    
    # 生徒数分ループ
    for ($c=1; $c -le $students; $c++){
        
        # 生徒のエントリを作成
        # 0埋めの桁ぞろえを設定
        $userid = "{0:0000000}" -f $serial
        $userPrincipalName = $prefix_id+$userid+$domainname
        $displayname = $prefix_displayname+$userid

        # エントリを初期化
        $DATA = New-Object psobject | Select-Object UserPrincipalName,SurName,GivenName,DisplayName,JobTitle,PhysicalDeliveryOfficeName,Department,PostalCode,StreetAddress,Mobile,City,State,UsageLocation,Country,AccountSkuId

        # データを入力
        $DATA.userPrincipalName= $userPrincipalName
        $DATA.SurName=""
        $DATA.GivenName=""
        $DATA.DisplayName=$displayname
        $DATA.JobTitle=$JobTitle
        $DATA.PhysicalDeliveryOfficeName=$schoolname
        $DATA.Department=""
        $DATA.PostalCode=""
        $DATA.StreetAddress=""
        $DATA.Mobile=""
        $DATA.City=""
        $DATA.State=$State
        $DATA.UsageLocation=$UsageLocation
        $DATA.Country=$Country
        $DATA.AccountSkuId=""

        # 出力用の配列に入力
        $DATAs += $DATA
        
        # 生徒のIDを+1
        $serial++  
    }
    
    # 配列に学校分のエントリが作成されたら学校毎のファイルに出力
    $DATAs | Export-Csv $filename -Encoding UTF8 -NoTypeInformation          
}