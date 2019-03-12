module hunt.service.remoting.invoker.RpcInvokerFactory;

import grpc;
import hunt.collection.HashMap;
import hunt.collection.Map;
import neton.client.NetonFactory;
import neton.client.registry.RegistryService;
import neton.client.NetonOption;
import neton.client.registry.Instance;
import neton.client.Listener;
import neton.client.Event;
import hunt.logging;
import std.random;

public class RpcInvokerFactory {

	private
	{
		RegistryService _register;
		Instance[][string]	_services;
		NetonOption _neton;
	}

	this(NetonOption neton)
	{
		assert(neton.ip.length > 0);
		_neton = neton;
		_register = NetonFactory.createRegistryService(_neton);
	}

	void invoker(string[] services...)
	{
		synchronized(this)
		{
			foreach(serviceName; services) {
			if(!(serviceName in _services))
			{
				_register.subscribe(serviceName,new class Listener{
					override void onEvent(Event event)
					{
						logInfo("service listen : ",event);
						_services[serviceName] = _register.getAllInstances(serviceName);
					}
				});
				auto instances = _register.getAllInstances(serviceName);
				_services[serviceName] = instances;
				logInfo("invoker service : ",serviceName," all instance :",instances);
			}
		}
		}
		
	}

	T getObject(T)(string serviceName)
	{
		if(serviceName in _services)
		{
			auto instances = _services[serviceName];
			if(instances.length > 0)
			{
				auto idx = uniform(0,instances.length);
				logInfof("random ip : %s , port : %d ",instances[idx].ip, instances[idx].port);
				auto channel = new GrpcClient(instances[idx].ip, instances[idx].port);
				return new T(channel);
			}
		}

		return null;
	}
}
