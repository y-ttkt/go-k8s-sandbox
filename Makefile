DC       := docker compose
SERVICE  := app
CONFIG_DIR  := .proglog

.PHONY: init
init:
	$(DC) exec $(SERVICE) sh -c 'mkdir -p $$HOME/$(CONFIG_DIR)'

.PHONY: gencert
gencert:
	$(DC) exec $(SERVICE) sh -c 'cfssl gencert -initca test/ca-csr.json | cfssljson -bare ca'

	$(DC) exec $(SERVICE) sh -c '\
		cfssl gencert \
			-ca=ca.pem \
			-ca-key=ca-key.pem \
			-config=test/ca-config.json \
			-profile=server \
			test/server-csr.json | cfssljson -bare server \
	'

	$(DC) exec $(SERVICE) sh -c '\
    	cfssl gencert \
			-ca=ca.pem \
			-ca-key=ca-key.pem \
			-config=test/ca-config.json \
			-profile=client \
			test/client-csr.json | cfssljson -bare client \
    '

	$(DC) exec $(SERVICE) sh -c '\
    	cfssl gencert \
        	-ca=ca.pem \
        	-ca-key=ca-key.pem \
        	-config=test/ca-config.json \
        	-profile=client \
        	-cn="root" \
        	test/client-csr.json | cfssljson -bare root-client \
    '

	$(DC) exec $(SERVICE) sh -c '\
    	cfssl gencert \
        	-ca=ca.pem \
        	-ca-key=ca-key.pem \
        	-config=test/ca-config.json \
        	-profile=client \
        	-cn="nobody" \
        	test/client-csr.json | cfssljson -bare nobody-client \
    '

	$(DC) exec $(SERVICE) sh -c 'mv *.pem *.csr $$HOME/$(CONFIG_DIR)'

PROTOC_CMD := protoc api/v1/*.proto \
	--go_out=. \
	--go-grpc_out=. \
	--go_opt=paths=source_relative \
	--go-grpc_opt=paths=source_relative \
	--proto_path=.

.PHONY: compile
compile:
	$(DC) exec $(SERVICE) sh -c '$(PROTOC_CMD)'

.PHONY: shell
shell:
	$(DC) exec $(SERVICE) bash


.PHONY: setup-policy
setup-policy: init
	$(DC) exec $(SERVICE) sh -c 'cp test/model.conf $$HOME/$(CONFIG_DIR)/model.conf'
	$(DC) exec $(SERVICE) sh -c 'cp test/policy.csv $$HOME/$(CONFIG_DIR)/policy.csv'


.PHONY: test
test: setup-policy
	$(DC) exec $(SERVICE) go test -race ./...