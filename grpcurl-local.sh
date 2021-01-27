#!/usr/bin/env bash

# TODO: fill
tenant_domain="<your_tenant_domain>"
client_id="<your_client_id>"
client_secret="<your_client_secret>"

access_token=$(curl --request POST \
  --url https://${tenant_domain}.auth0.com/oauth/token \
  --header 'content-type: application/json' \
  --data '{"client_id":"'${client_id}'","client_secret":"'${client_secret}'","audience":"go-grpc-20210125","grant_type":"client_credentials"}' | jq -r .access_token)

grpcurl \
  -plaintext \
  -H "Authorization: Bearer ${access_token}" \
  -d '{"name": "arai"}' \
  -import-path proto \
  -proto helloworld.proto \
  localhost:50051 helloworld.Greeter/SayHello