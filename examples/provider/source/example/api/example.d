// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: example.proto

module example.api.example;

import google.protobuf;

enum protocVersion = 3006001;

class HelloRequest
{
    @Proto(1) string name = protoDefaultValue!string;
}

class HelloResponse
{
    @Proto(1) string echo = protoDefaultValue!string;
}
