import std.stdio;

import example.api.examplerpc;
import example.api.example;
import hunt.service.remoting.invoker.RpcInvokerFactory;
import hunt.service.conf;
import neton.client.NetonOption;
import hunt.net;
import std.conv;

void main()
{
	writeln("Edit source/app.d to start your project.");
	NetUtil.startEventLoop();

	auto invokerFactory = new RpcInvokerFactory();
	RegistryConfig conf = {"127.0.0.1",50051,"example.provider"};
	// invokerFactory.setRegistry(conf);
	invokerFactory.setDirectUrl("tcp://127.0.0.1:7788");

	auto client = invokerFactory.createClient!(HelloClient)();
	assert(client !is null);

	HelloRequest req = new HelloRequest();

	foreach(num; 1 .. 10) {
		req.name = to!string(num);
		auto respon = client.sayHello(req);

		writeln("response : ",respon.echo);
	}
	
}
