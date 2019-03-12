#!/bin/bash

protoc --plugin="/home/zhyc/share/pt_cpp/protobuf-d/build/protoc-gen-d" --d_out=./../ -I./  example.proto 
protoc --plugin=protoc-gen-grpc=grpc_dlang_plugin --grpc_out=./../example/api -I./ example.proto
