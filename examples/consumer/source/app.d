import std.stdio;

import example.api.examplerpc;
import example.api.example;
import hunt.service.remoting.invoker.RpcInvokerFactory;

import neton.client.NetonOption;
import hunt.net;
import std.conv;

void main()
{
	writeln("Edit source/app.d to start your project.");
	NetUtil.startEventLoop();

	NetonOption neton = {"127.0.0.1",50051};

	auto factory = new RpcInvokerFactory(neton);
	factory.invoker("example.provider");

	auto client = factory.getObject!(HelloClient)("example.provider");
	assert(client !is null);

	HelloRequest req = new HelloRequest();

	foreach(num; 1 .. 10) {
		req.name = to!string(num);
		auto respon = client.sayHello(req);

		writeln("response : ",respon.echo);
	}
	
}
