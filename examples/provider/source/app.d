import std.stdio;

import HelloService;
import hunt.service.remoting.provider.RpcProviderFactory;
import neton.client.NetonOption;
import hunt.net;
import hunt.service.conf;

void main()
{
	writeln("Edit source/app.d to start your project.");
	NetUtil.startEventLoop();

	RegistryConfig conf = {"127.0.0.1",50051,"example.provider"};

	auto providerFactory = new RpcProviderFactory("127.0.0.1",7788);
	// providerFactory.setRegistry(conf);
	providerFactory.addService(new HelloService());

	providerFactory.start();

}
