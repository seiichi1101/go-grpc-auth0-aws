# go-grpc-auth0-aws

## Architecture

![](./pics/go-grpc-auth0.png)

## Init

下記パラメータを埋めてください

- `server/server.go`
  - `auth0_url`, `audience`
- `grpcurl-aws.sh`
  - `tenant_domain`, `client_id`, `client_secret`
- `grpcurl-local.sh`
  - `tenant_domain`, `client_id`, `client_secret`

## Deployment

2021.01.26時点では、Terraformが`ALB protocol_version:GRPC`に対応していないため工夫が必要です。

また、HTTPS通信が必須となっているので、事前にサーバー証明書が必要です。ここでは、ドメインはRoute53で登録済みであり、`go-grpc-server`というサブドメインの証明書がACMで発行済であるという前提で進めています。

下記の手順に沿って実施してください。

1. VPCのリソースだけ先にデプロイ（ターゲットグループの作成に必要なため）

```bash
terraform plan -target=aws_vpc.vpc -var "aws_account_id=<your-aws-account-id>" -var "domain=<your-domain>"
terraform apply -target=aws_vpc.vpc -var "aws_account_id=<your-aws-account-id>" -var "domain=<your-domain>"
```

2. AWSコンソールもしくはAWS CLIでgRPC用のターゲットグループを作成

[aws cli v1 elbv2 create-target-group](https://docs.aws.amazon.com/cli/latest/reference/elbv2/create-target-group.html)であれば、`protocol-version`に`GRPC`を追加すればCLIで出来そうです。

[aws cli v1 elbv2 create-target-group](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/elbv2/create-target-group.html)はオプションがないので、手動作成が必要そうです。

- 入力パラメータ
  - protocol: `HTTP`
  - protocol-version: `GRPC`
  - port: `50051`
  - vpc-id: 先ほど作成したvpcのid
  - target-type: `ip`

3. `elb.tf`のターゲットグループのARNを埋める

4. 全体をデプロイ

```bash
terraform plan -var "aws_account_id=<your-aws-account-id>" -var "domain=<your-domain>"
terraform apply -var "aws_account_id=<your-aws-account-id>" -var "domain=<your-domain>"
```
