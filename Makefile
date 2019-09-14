SS_PORT=8888
KCPTUN_PORT=8000
REGION=ap-southeast-1
STACK_NAME=vpn
INSTANCE_TYPE=t2.micro
PASSWORD=password

deploy: validate
	aws cloudformation deploy \
	--stack-name $(STACK_NAME) \
	--template-file template.yaml \
	--parameter-overrides \
		ShadowsocksPort="$(SS_PORT)" \
		kcptunPort="$(KCPTUN_PORT)" \
		InstanceType="$(INSTANCE_TYPE)" \
		Password="$(PASSWORD)" \
	--capabilities CAPABILITY_IAM \
	--region $(REGION)
	@echo -e '\n\n\n'
	@echo =====================================
	@echo ===== Configuration Information ===== 
	@echo =====================================
	@echo -e '\nShadowsocks Server URL:' 
	aws cloudformation describe-stacks --stack-name $(STACK_NAME) --region $(REGION) --query 'Stacks[0].Outputs[?OutputKey==`ShadowsocksUrl`].OutputValue' --output text
	@echo -e '\nShadowsocks Server URL QR Code:'
	aws cloudformation describe-stacks --stack-name $(STACK_NAME) --region $(REGION) --query 'Stacks[0].Outputs[?OutputKey==`ShadowsocksQrCodeUrl`].OutputValue' --output text
	@echo -e '\nPre Shared Key for L2TP/IPSec:'
	@echo vpn.${ROOT_DOMAIN_NAME}
	@echo -e '\nUsername and Password for L2TP/IPSec and PPTP:'
	@echo -e 'Username:\tvpn.${ROOT_DOMAIN_NAME}'
	@echo -e 'Password:\t${PASSWORD}'
	@echo =====================================
	@echo =====================================
	@echo =====================================
	@echo -e '\n\n\n'
	
undeploy:
	$(eval S3_BUCKET := $(shell aws cloudformation describe-stacks --stack-name $(STACK_NAME) --region $(REGION) --query 'Stacks[0].Outputs[?OutputKey==`S3Bucket`].OutputValue' --output text))
	aws s3 rb s3://$(S3_BUCKET) --force --region $(REGION)
	aws cloudformation delete-stack --stack-name $(STACK_NAME) --region $(REGION)
	

validate:
	aws cloudformation validate-template --template-body file://template.yaml