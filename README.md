
## Getting started

The following code snippet comes from [Hunt-service examples](https://github.com/huntlabs/hunt-service). You may clone the sample project.

```bash
# git clone https://github.com/huntlabs/hunt-service.git
# cd examples
```

### Define rpc service 

```dlang
syntax = "proto3";

package example.api;



service Hello {
 
  rpc sayHello(HelloRequest) returns (HelloResponse) {

  }

}

message HelloRequest{
  string name = 1;
}

message HelloResponse{
  string echo = 1;
}
```

*See [example/proto/example.proto](https://github.com/huntlabs/hunt-service/blob/master/examples/proto/example.proto) on GitHub.*

### Implement service interface for the provider

```dlang
module HelloService;

import example.api.examplerpc;
import example.api.example;
import grpc;

class HelloService : HelloBase
{
	override Status sayHello(HelloRequest req, ref HelloResponse resp)
    { 
        resp.echo = "hello ," ~ req.name;
        return Status.OK; 
    }

}
```

*See [provider/source/HelloService.d](https://github.com/huntlabs/hunt-service/blob/master/examples/provider/source/HelloService.d) on GitHub.*

### Start service provider

```dlang
NetUtil.startEventLoop();

auto providerFactory = new RpcProviderFactory("127.0.0.1",7788);

// If you use a registry, use the following options
// RegistryConfig conf = {"127.0.0.1",50051,"example.provider"};
// providerFactory.setRegistry(conf);

providerFactory.addService(new HelloService());
providerFactory.start();
```

*See [provider/source/app.d](https://github.com/huntlabs/hunt-service/blob/master/examples/provider/source/app.d) on GitHub.*

### Build and run the provider

```bash
# cd provide
# dub run
```

### Call remote service in consumer

```dlang
NetUtil.startEventLoop();

auto invokerFactory = new RpcInvokerFactory();

// If you use a registry, use the following options
// RegistryConfig conf = {"127.0.0.1",50051,"example.provider"};
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
```

### Build and run the consumer

```bash
# cd consumer
# dub run
```

*See [consumer/source/app.d](https://github.com/huntlabs/hunt-service/blob/master/examples/consumer/source/app.d) on GitHub.*
