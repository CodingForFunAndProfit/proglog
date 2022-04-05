# CONFIG_PATH=${HOME}/.proglog/
CONFIG_PATH=/c/Users/floxn/.proglog/
# .PHONY: init
# init:
#	mkdir -p ${CONFIG_PATH}

.PHONY: gencert
gencert:
	cfssl gencert \
		-initca test/ca-csr.json | cfssljson -bare ca
	cfssl gencert \
		-ca=ca.pem \
		-ca-key=ca-key.pem \
		-config=test/ca-config.json \
		-profile=server \
		test/server-csr.json | cfssljson -bare server
	mv *.pem *.csr ${CONFIG_PATH}

.PHONY: test
test:
	go test -race ./...

.PHONY: compile
compile:
	protoc  \
		--go_out=plugins=grpc:. api/v1/*.proto \
		--go_opt=paths=source_relative \
		--proto_path=.