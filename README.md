# go-grpc-auth0-aws

## Architecture

![](./pics/go-grpc-auth0.png)

## Init

- Fill these properties
  - `server/server.go`
    - `auth0_url`, `audience`
  - `grpcurl-aws.sh`
    - `tenant_domain`, `client_id`, `client_secret`
  - `grpcurl-local.sh`
    - `tenant_domain`, `client_id`, `client_secret`
