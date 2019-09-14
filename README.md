# AWS EC2 Integrated VPN Server
This Cloudformation stack will run a EC2 instance which use Docker to contain Shadowsocks, kcptun, PPTP and L2TP/IPsec server.

- Shadowsocks & kcptun - [mritd/shadowsocks](https://hub.docker.com/r/mritd/shadowsocks/ "mritd/shadowsocks")
	- **Shadowsocks** is used to break through the* Great Fire Wall (GFW)* to view blocked, obscured or disturbed content.
	- **kcptun** is used to improving the throughput and latency between the connection of Shadowsocks client and server.
- L2TP/IPsec - [hwdsl2/ipsec-vpn-server](https://hub.docker.com/r/hwdsl2/ipsec-vpn-server/ "hwdsl2/ipsec-vpn-server")
- PPTP - [mobtitude/vpn-pptp](https://hub.docker.com/r/mobtitude/vpn-pptp/ "mobtitude/vpn-pptp")

## Express Deployment - Windows 10
1. [Create a user in IAM with Administrator policy](https://docs.aws.amazon.com/zh_tw/IAM/latest/UserGuide/id_users_create.html#id_users_create_console) (Programmatic access Only) [Video Tutorial](https://www.youtube.com/watch?v=665RYobRJDY)
***!!!!! Please mark down your Access Key Pair !!!!!***
3. Run *Powershell **as Administrator***
4. Copy the following command and run in Powershell.
```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://bitbucket.org/iAmJustALittleITDog/aws-ec2-integrated-vpn-server/raw/4647fe7eb6b98549100c938f30c0513a220601de/express-deploy.ps1'))
```
## Advanced Deployment - Bash
1. [Install AWS CLI](https://aws.amazon.com/tw/cli/)
2. [Create a user in IAM with Admin policy](https://docs.aws.amazon.com/zh_tw/IAM/latest/UserGuide/id_users_create.html#id_users_create_console)
3. [Configure AWS CLI Credential](https://docs.aws.amazon.com/zh_tw/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration)
4. Run the following command in terminal
```sh
git clone https://github.com/MikletNg/aws-ec2-integrated-vpn-server
cd aws-ec2-integrated-vpn-server
make deploy -s \
    PASSWORD='YOUR_OWN_PASSWORD'
```
5. After deployment, go to Cloudformation consle. And check the stack output for the Shadowsocks server URL and the IKEv2 server configuration file.
## Advanced Undeployment - Bash
```sh
make undeploy -is
```
## Parameters in Makefile
- PASSWORD*
	- The password use to connect to VPN
- SS_PORT
	- The port number use by Shadowsocks
- KCPTUN_PORT
	- The port number used by kcptun
- STACK_NAME
	- Name of the Cloudformation stack
- INSTANCE_TYPE
	- Instance type of EC2, must be t2 or t3. (Hong Kong Region do not provide t2 instance)
- REGION
	- AWS region to deploy
