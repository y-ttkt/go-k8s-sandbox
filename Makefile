DC       := docker compose
SERVICE  := app

PROTOC_CMD := protoc api/v1/*.proto \
	--go_out=. \
	--go_opt=paths=source_relative \
	--proto_path=.

.PHONY: proto
proto:
	$(DC) exec $(SERVICE) sh -c '$(PROTOC_CMD)'
