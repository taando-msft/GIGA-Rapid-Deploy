# GIGA-Rapid-Deploy
GIGA スクール構想における Rapid Deploy 用のサンプルスクリプトです。Office 365 アカウントの作成からテナントへのインポートまでを PowerShell で一括管理します。
# 前提条件
次の Windows のバージョンを使用できます。  
・Windows 10、Windows 8.1、Windows 8、または Windows 7 Service Pack 1 (SP1)  
・Windows Server 2019、Windows Server 2016、Windows Server 2012 R2、Windows Server 2012、または Windows Server 2008 R2 SP1

[Office 365 PowerShell への接続](https://docs.microsoft.com/ja-jp/office365/enterprise/powershell/connect-to-office-365-powershell)  


# 利用方法
## 学校名と人数の作成
1. Cドライブ直下に専用のフォルダー（C:¥xxxx）を作成します。  
2. リポジトリからzipファイルをダウンロードし、C:¥xxxxに保存します。
3. schoollist.csvを開き、任意の学校名と人数を記載して、UTF-8形式で保存します。 

## ユーザーアカウントの作成  
3. CreateCSV.ps1ファイルを開きます。  
Set-Location -Path C:\xxxxxのパスを1.で指定したフォルダー名に変更します。<br>　　
$domainname = "@.onmicrosoft.com"のxxxxx部分をテナントのサブドメイン名に変更します。<br>
CreateCSV.ps1ファイルを保存します。  
4. Windows PowerShell を開き、CreateCSV.ps1のパスを指定して実行します。例：C:\xxxx\CreateCSV.ps1  
5.C:¥xxxxのフォルダー配下にoutputフォルダーが作成されるため、学校名と人数が記載されたCSVファイルが作成されます。  
※スクリプトの実行に失敗する場合は Set-Execution RemoteSigned コマンドレットを実行してから再実行してください。  

## Office 365 へのインポート　　
6. CreateSchoolAccounts.ps1を開き、Set-Location -Path "C:\xxxxx"のパスを1.で指定したフォルダー名に変更します。  
7. $tenantName = "xxxxxx"と$username = "admin@xxxxxx.onmicrosoft.com"の値をテナント名に変更します。




