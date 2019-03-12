
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