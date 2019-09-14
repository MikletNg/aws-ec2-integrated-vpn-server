Set-Location "C:\Windows\system32" 
Set-ExecutionPolicy RemoteSigned -Force 
$TempPath = $env:TEMP 
$UserProfilePath = $env:userprofile
$Password = Invoke-RestMethod -Uri "https://helloacm.com/api/random/?n=8"

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y git.install awscli

Write-Host "================ AWS Credential ================"
$AccessKeyID = Read-Host -Prompt 'AWS Access Key ID'
$SecretAccessKey = Read-Host -Prompt 'AWS Secret Access Key'
Write-Host "================================================"

New-Item $TempPath\aws-credential.txt -Force | Out-Null
Set-Content $TempPath\aws-credential.txt "$AccessKeyID`r`n$SecretAccessKey`r`nap-southeast-1`r`njson"
type $TempPath\aws-credential.txt | aws configure
Remove-Item -LiteralPath $TempPath\aws-credential.txt -Force -Recurse

Set-Location $UserProfilePath\Documents
git clone https://iAmJustALittleITDog@bitbucket.org/iAmJustALittleITDog/aws-ec2-integrated-vpn-server.git

Set-Location aws-ec2-integrated-vpn-server

aws cloudformation deploy --stack-name vpn --template-file template.yaml --parameter-overrides Password=$Password --capabilities CAPABILITY_IAM --region ap-southeast-1
    
Write-Host "====================================="
Write-Host "===== Configuration Information ====="
Write-Host "====================================="
Write-Host "`nShadowsocks Server URL:"
aws cloudformation describe-stacks --stack-name vpn --region ap-southeast-1 --query 'Stacks[0].Outputs[?OutputKey==`ShadowsocksUrl`].OutputValue' --output text
Write-Host "`nShadowsocks Server URL QR Code:"
aws cloudformation describe-stacks --stack-name vpn --region ap-southeast-1 --query 'Stacks[0].Outputs[?OutputKey==`ShadowsocksQrCodeUrl`].OutputValue' --output text
Write-Host "`nL2TP/IPSec Credential:"
aws cloudformation describe-stacks --stack-name vpn --region ap-southeast-1 --query 'Stacks[0].Outputs[?OutputKey==`L2TPIPsecCredential`].OutputValue' --output text
Write-Host "`nPPTP Credential::"
aws cloudformation describe-stacks --stack-name vpn --region ap-southeast-1 --query 'Stacks[0].Outputs[?OutputKey==`PPTPCredential`].OutputValue' --output text
Write-Host "====================================="
Write-Host "====================================="
Write-Host "====================================="
Write-Host "`n`n`n"