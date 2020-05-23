# GIGA-Rapid-Deploy
GIGA スクール構想における Rapid Deploy 用のサンプルスクリプトです。Office 365 アカウントの作成からテナントへのインポートまでを PowerShell で一括管理します。

# 前提条件
[Office 365 PowerShell への接続](https://docs.microsoft.com/ja-jp/office365/enterprise/powershell/connect-to-office-365-powershell)を参考にPowerShellを利用するために必要なモジュールを事前にインストールしてください。


# 利用方法
## 学校名と人数の作成
1. Cドライブ直下に専用のフォルダー（C:¥xxxx）を作成します。  
2. リポジトリからzipファイルをダウンロードし、展開後、ファイルをC:¥xxxxに保存します。
3. schoollist.csvを開き、任意の学校名と人数を記載して、UTF-8形式で保存します。 

## ユーザーアカウントの作成  
3. SampleCreateCSV.ps1ファイルを開きます。<br>
4. Set-Location -Path C:\xxxxxのパスを1.で指定したフォルダー名に変更します。<br>
5. $domainname = "@.onmicrosoft.com"のxxxxx部分をテナントのサブドメイン名に変更します。<br>
6. SampleCreateCSV.ps1ファイルを別名（CreateCSV.ps1）で保存します。<br>
7. Windows PowerShell を [管理者として実行する] オプションから開き、CreateCSV.ps1のパスを指定して実行します。例：C:\xxxx\CreateCSV.ps1<br>
※ スクリプトの実行に失敗する場合は Set-ExecutionPolicy RemoteSigned コマンドレットを実行（「Y」を選択）してから再実行してください。<br>
8. C:¥xxxxのoutputフォルダー内に学校名と人数が記載されたCSVファイルが作成されていることを確認します。<br>
9. 8で作成されたCSVファイルをC:¥xxxxに保存します。<br>

## Office 365 へのインポート　　
10. SampleCreateSchoolAccounts.ps1を開きます。<br>
11. Set-Location -Path "C:\xxxxx"のパスを1.で指定したフォルダー名に変更します。<br>
12. $tenantName = "xxxxxx" をテナントのサブドメイン名に変更します。<br>
13. $username = "admin@xxxxxx.onmicrosoft.com" のxxxxxxをテナント名に変更します。<br>
14. $pass = ConvertTo-SecureString "xxxxxxxx" -AsPlainText -Force のxxxxxxxxをadminユーザーのパスワードに変更します。<br>
15. SampleCreateSchoolAccounts.ps1を別名（CreateSchoolAccounts.ps1）で保存します。
※ #ライセンスプランの部分で所有しているライセンスプランが不明な場合は Get-MsolAccountSku コマンドにて確認して変更します。<br>
16. SampleBatchCreateSchoolAccounts.ps1を開きます。<br>
17. .\CreateSchoolAccounts.ps1 に続けて作成した CSV ファイルの名前を入力します。<br>
18. SampleBatchCreateSchoolAccounts.ps1を別名（BatchCreateSchoolAccounts.ps1）で保存します。<br>
19. BatchCreateSchoolAccounts.ps1のパスを指定して実行します。例：C:\xxxx\BatchCreateSchoolAccounts.ps1<br> 
