import std.stdio;

import HelloService;

import hunt.service;

import hunt.net;

import neton.client.NetonOption;

void main()
{
	NetUtil.startEventLoop();

	RegistryConfig conf = {"127.0.0.1",50051,"example.provider"};

	auto providerFactory = new ServiceProviderFactory("127.0.0.1",7788);
	// providerFactory.setRegistry(conf);
	providerFactory.addService(new HelloService());

	providerFactory.start();
}
