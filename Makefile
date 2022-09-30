# Copyright 2022 The Flame Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

BIN_DIR=_output/bin
RELEASE_DIR=_output/release

all: flame-application-manager \
	flame-session-manager \
	flame-webhook-manager \
	flame-api-gateway

init:
	mkdir -p ${BIN_DIR}
	mkdir -p ${RELEASE_DIR}

grpc-pkg: init
	go get -u google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1
	go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1.0

grpc-gen: grpc-pkg
	protoc --plugin=protoc-gen-go=${GOPATH}/bin/protoc-gen-go \
		-I${GOPATH}/src/ \
		--go_out=${GOPATH}/src/xflops.cn/flame \
		--go-grpc_out=${GOPATH}/src/xflops.cn/flame/ \
		xflops.cn/flame/protos/flame.proto

flame-api-gateway: init grpc-gen
	go build -o=${BIN_DIR}/flame-api-gateway ./cmd/api-gateway

flame-application-manager: init
	go build -o=${BIN_DIR}/flame-application-manager ./cmd/application-manager

flame-session-manager: init grpc-gen
	go build -o=${BIN_DIR}/flame-session-manager ./cmd/session-manager

flame-webhook-manager: init
	go build -o=${BIN_DIR}/flame-webhook-manager ./cmd/webhook-manager
