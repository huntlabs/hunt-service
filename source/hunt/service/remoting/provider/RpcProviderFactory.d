module hunt.service.remoting.provider.RpcProviderFactory;

import grpc;
import hunt.collection.HashMap;
import hunt.collection.Map;
import neton.client.NetonFactory;
import neton.client.registry.RegistryService;
import neton.client.NetonOption;
import hunt.logging;

public class RpcProviderFactory
{

	private
	{
		Server _rpcServer;
		RegistryService _register;
		string _serviceName;
		NetonOption _neton;
		string _listenIp;
		ushort _listenPort;
	}

	this(NetonOption neton,string serviceName,string listenIp ,ushort listenPort)
	{
		assert(serviceName.length > 0);
		_neton = neton;
		_serviceName = serviceName;
		_listenIp = listenIp;
		_listenPort = listenPort;

		_rpcServer = new Server();
		_rpcServer.listen(_listenIp, _listenPort);
	}

	void addService(GrpcService service)
	{
		_rpcServer.register(service);
	}

	void start()
	{
		_register = NetonFactory.createRegistryService(_neton);
		assert(_register.registerInstance(_serviceName,_listenIp,_listenPort));

		_rpcServer.start();
	}
}
