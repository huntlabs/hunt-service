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
import hunt.service.util.UrlHelper;
import hunt.service.util.UrlInfo;
import hunt.service.conf;
import hunt.logging;
import std.random;


public class RpcInvokerFactory
{

	private
	{
		RegistryService _register;
		Instance[][string] _services;
		NetonOption _neton;
		bool _useRegistry = false;
		RegistryConfig _registryConf;
		UrlInfo _urlInfo;
	}

	this()
	{
	}

	T createClient(T)()
	{
		if (_useRegistry)
		{
			if (_registryConf.serviceName in _services)
			{
				auto instances = _services[_registryConf.serviceName];
				if (instances.length > 0)
				{
					auto idx = uniform(0, instances.length);
					logInfof("random ip : %s , port : %d ", instances[idx].ip, instances[idx].port);
					auto channel = new GrpcClient(instances[idx].ip, instances[idx].port);
					return new T(channel);
				}
			}
		}
		else
		{
			auto channel = new GrpcClient(_urlInfo.getHost(), cast(ushort)(_urlInfo.getPort()));
			return new T(channel);
		}

		return null;
	}

	void setDirectUrl(string url)
	{
		_useRegistry = false;
		_urlInfo = new UrlInfo;
		_urlInfo = UrlHelper.toProviderInfo(url);
	}

	void setRegistry(RegistryConfig conf)
	{
		_useRegistry = true;
		_registryConf = conf;
		_neton.ip = conf.ip;
		_neton.port = conf.port;
		_register = NetonFactory.createRegistryService(_neton);

		if (!(conf.serviceName in _services))
		{
			//dfmt off
			_register.subscribe(conf.serviceName, new class Listener
				{
					override void onEvent(Event event)
					{
						logInfo("service listen : ", event); 
						_services[conf.serviceName] = _register.getAllInstances(conf.serviceName);
					}
				}
				);
			//dfmt on
			auto instances = _register.getAllInstances(conf.serviceName);
			_services[conf.serviceName] = instances;
			logInfo("invoker service : ", conf.serviceName, " all instance :", instances);
		}
	}
}
