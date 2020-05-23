# 学校ごとの読み込みCSVをインポートし、順次アカウントを登録するスクリプトです。
Param
(
    [Parameter(Mandatory = $true)]
    [string] $InputSchoolDataCsv,
    [Parameter(Mandatory = $false)]
    [string] $SLogFolder = ".\slog", #登録成功アカウント出力先フォルダ
    [Parameter(Mandatory = $false)]
    [string] $ELogFolder = ".\elog", #登録エラーアカウント出力先フォルダ
    [Parameter(Mandatory = $false)]
    [string] $rFolder = ".\result" #最終結果出力先フォルダ
)

# 登録完了アカウント情報出力
function WriteSLog([string]$Upn) {
    $Message = $Upn
    If (!(Test-Path $Script:SLogFolder)) {
        New-Item "slog" -ItemType directory | out-null
    }
    Write-Output $Message | Out-File (Join-Path $Script:SLogFolder ($logFileName)) -Append -Encoding UTF8
}

# 登録失敗アカウント情報出力
function WriteELog([string]$Upn) {
    $Message = $Upn
    If (!(Test-Path $Script:ELogFolder)) {
        New-Item "elog" -ItemType directory | out-null
    }
    Write-Output $Message | Out-File (Join-Path $Script:ELogFolder ($logFileName)) -Append -Encoding UTF8
}

Set-Location -Path "C:\xxxxx"

$startTime = Get-Date

# ログファイル名
$logFileName = "{0}_{1}.log" -f (Get-Date -Format "yyyy-MM-dd-HHmm"), $InputSchoolDataCsv

#connect to Azure
$tenantName = "xxxxxx"
$username = "admin@xxxxxx.onmicrosoft.com"
$pass = ConvertTo-SecureString "xxxxxxxx" -AsPlainText -Force
$UserCredential = New-Object system.management.automation.pscredential($username, $pass)
Connect-MsolService -Credential $UserCredential

#CSVファイル読み込み
$AccountData = Import-Csv $InputSchoolDataCsv

$UsageLocation = "JP"
#ライセンスプラン
$LicenseAssignmentFACULTY = "{0}:STANDARDWOFFPACK_FACULTY" -f $tenantName
$LicenseAssignmentSTUDENT = "{0}:STANDARDWOFFPACK_STUDENT" -f $tenantName
#初回パスワード変更強制フラグ
$ForceChangePassword = $false
$allCount = 0
$sCount = 0
$eCount = 0

$AccountData | ForEach-Object {
    if ($_.jobTitle -eq "Teacher") {
        $LicenseAssignment = $LicenseAssignmentFACULTY
    }
    else {
        $LicenseAssignment = $LicenseAssignmentSTUDENT
    } 

    New-MsolUser -UserPrincipalName $_.userPrincipalName -DisplayName $_.displayName -Password $_.passwordProfile -Office $_.physicalDeliveryOfficeName -Title $_.jobTitle –Department $_.department –StreetAddress $_.streetAddress -LicenseAssignment $LicenseAssignment -UsageLocation $UsageLocation -ForceChangePassword $ForceChangePassword -PasswordNeverExpires $true

    if ($? -eq $true) {
        Write-Host $_.userPrincipalName -ForegroundColor Green
        WriteSLog $_.userPrincipalName
        $sCount++

    }
    else {
        Write-Host $_.userPrincipalName -ForegroundColor Red
        WriteELog $_.userPrincipalName
        $eCount++
    }
    $allCount++
}

$endTime = Get-Date

$summary = "{0},{1},{2},{3},{4},{5},{6}" -f $InputSchoolDataCsv, $startTime.toString( 'yyyy/MM/dd HH:mm:ss'), $endTime.toString( 'yyyy/MM/dd HH:mm:ss'), ($endTime - $startTime).TotalMinutes, $allCount, $sCount, $eCount

If (!(Test-Path $Script:rFolder)) {
    New-Item "result" -ItemType directory | out-null
}
# 結果サマリ出力ファイル名
$resultFileName = "{0}_result.csv" -f (Get-Date -Format "yyyy-MM-dd")

Write-Output $summary | Out-File (Join-Path $Script:rFolder ($resultFileName)) -Append -Encoding UTF8

Write-Host  "TargetCSV, Start, End, Duration(Minutes), AllCount, Success, Failure" -f Yellow
Write-Host  $summary -f Yellow

