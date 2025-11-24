DC       := docker compose
SERVICE  := app

PROTOC_CMD := protoc api/v1/*.proto \
	--go_out=. \
	--go-grpc_out=. \
	--go_opt=paths=source_relative \
	--go-grpc_opt=paths=source_relative \
	--proto_path=.

.PHONY: compile
compile:
	$(DC) exec $(SERVICE) sh -c '$(PROTOC_CMD)'
