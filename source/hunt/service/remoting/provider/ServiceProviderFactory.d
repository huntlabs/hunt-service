module hunt.service.remoting.provider.ServiceProviderFactory;

import grpc;

import hunt.collection.HashMap;
import hunt.collection.Map;
import hunt.logging;
import hunt.service.RegistryConfig;

import neton.client.NetonFactory;
import neton.client.registry.RegistryService;
import neton.client.NetonOption;

public class ServiceProviderFactory
{

	private
	{
		Server _rpcServer;
		RegistryService _register;
		string _serviceName;
		NetonOption _neton;
		string _listenIp;
		ushort _listenPort;
		bool _useRegistry = false;
		RegistryConfig _registryConf;
	}

	this(string listenIp ,ushort listenPort)
	{
		_listenIp = listenIp;
		_listenPort = listenPort;

		_rpcServer = new Server();
		_rpcServer.listen(_listenIp, _listenPort);
	}

	void setRegistry(RegistryConfig conf)
	{
		assert(conf.serviceName.length > 0);
		_useRegistry = true;
		_registryConf = conf;
		_serviceName = conf.serviceName;
		_neton.ip = conf.ip;
		_neton.port = conf.port;
	}

	void addService(GrpcService service)
	{
		_rpcServer.register(service);
	}

	void start()
	{
		if(_useRegistry)
		{
			_register = NetonFactory.createRegistryService(_neton);
			assert(_register.registerInstance(_serviceName,_listenIp,_listenPort));
		}

		_rpcServer.start();
	}
}
