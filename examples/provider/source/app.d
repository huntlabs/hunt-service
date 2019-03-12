import std.stdio;

import HelloService;
import hunt.service.remoting.provider.RpcProviderFactory;
import neton.client.NetonOption;
import hunt.net;

void main()
{
	writeln("Edit source/app.d to start your project.");
	NetUtil.startEventLoop();

	NetonOption neton = {"127.0.0.1",50051};

	auto factory = new RpcProviderFactory(neton,"example.provider","127.0.0.1",7788);
	factory.addService(new HelloService());

	factory.start();

}
