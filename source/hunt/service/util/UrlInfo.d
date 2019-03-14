
module hunt.service.util.UrlInfo;

import hunt.collection.Map;
import hunt.collection.HashMap;
import hunt.service.util.UrlHelper;
import hunt.Integer;
import std.conv;

public class UrlInfo  {

    private enum long                             serialVersionUID = -6438690329875954051L;

    /**
     * 原始地址
     */
    private  string                              originUrl;

    /**
     * The Protocol type.
     */
    private string                                        protocolType     = "TCP";
    /**
     * The Ip.
     */
    private string                                        host;

    /**
     * The Port.
     */
    private int                                           port             = 80;

    /**
     * The path
     */
    private string                                        path;

    /**
     * 序列化方式，服务端指定，以服务端的为准
     */
    private string                                        serializationType;

    /**
     * The rpc Version
     */
    private int                                           rpcVersion;

    /**
     * 权重
     *
     * @see UrlInfoAttrs#ATTR_WEIGHT 原始权重
     * @see UrlInfoAttrs#ATTR_WARMUP_WEIGHT 预热权重
     */
    private   int                        weight           = 100;

    /**
     * 服务状态
     */
    // private  ProviderStatus             status           = ProviderStatus.AVAILABLE;

    /**
     * 静态属性，不会变的
     */
    private  Map!(string,string)           staticAttrs   ;

    /**
     * 动态属性，会动态变的 <br />
     * <p>
     * 例如动态权重，是否启用，预热标记等  invocationOptimizing
     */
    private   Map!(string,Object) dynamicAttrs ;

    public void init()
    {
        staticAttrs      = new HashMap!(string,string)();
        dynamicAttrs     = new HashMap!(string,Object)();
    }

    /**
     * Instantiates a new Provider.
     */
    public this() {
        init();
    }
    
    /**
     * Instantiates a new Provider.
     *
     * @param host the host
     * @param port the port
     */
    public this(string host, int port) {
        init();
        this.host = host;
        this.port = port;
    }

    /**
     * Instantiates a new Provider.
     *
     * @param host      the host
     * @param port      the port
     * @param originUrl the Origin url
     */
    public this(string host, int port, string originUrl) {
        init();
        this.host = host;
        this.port = port;
        this.originUrl = originUrl;
    }

    /**
     * 从URL里解析Provider
     *
     * @param url url地址
     * @return Provider对象 provider
     * @deprecated use {@link UrlHelper#toProviderInfo(string)}
     */
    
    public static UrlInfo valueOf(string url) {
        return UrlHelper.toProviderInfo(url);
    }

    /**
     * 序列化到url.
     *
     * @return the string
     * @deprecated use {@link UrlHelper#toUrl(UrlInfo)}
     */
    
    public string toUrl() {
        return UrlHelper.toUrl(this);
    }

    override
    public bool opEquals(Object o) {
        if (this is o) {
            return true;
        }
        if (o is null || typeid(this) != typeid(o)) {
            return false;
        }

        UrlInfo that = cast(UrlInfo) o;

        if (port != that.port) {
            return false;
        }
        if (rpcVersion != that.rpcVersion) {
            return false;
        }
        if (protocolType !is null ? !(protocolType == (that.protocolType)) : that.protocolType !is null) {
            return false;
        }
        if (host !is null ? !(host == (that.host)) : that.host !is null) {
            return false;
        }
        if (path !is null ? !(path == (that.path)) : that.path !is null) {
            return false;
        }
        if (serializationType !is null ? !(serializationType == (that.serializationType))
            : that.serializationType !is null) {
            return false;
        }
        // return staticAttrs !is null ? staticAttrs.equals(that.staticAttrs) : that.staticAttrs is null;
        return true;
    }

    override
    public nothrow @trusted size_t toHash() {
        size_t result = (protocolType !is null ? protocolType.hashOf() : 0);
        result = 31 * result + (host !is null ? host.hashOf() : 0);
        result = 31 * result + port;
        result = 31 * result + (path !is null ? path.hashOf() : 0);
        result = 31 * result + (serializationType !is null ? serializationType.hashOf() : 0);
        result = 31 * result + rpcVersion;
        // result = 31 * result + (staticAttrs !is null ? staticAttrs.hashCode() : 0);
        return result;
    }

    /**
     * Gets origin url.
     *
     * @return the origin url
     */
    public string getOriginUrl() {
        return originUrl;
    }

    /**
     * Sets origin url.
     *
     * @param originUrl the origin url
     * @return the origin url
     */
    public UrlInfo setOriginUrl(string originUrl) {
        this.originUrl = originUrl;
        return this;
    }

    /**
     * Gets protocol type.
     *
     * @return the protocol type
     */
    public string getProtocolType() {
        return protocolType;
    }

    /**
     * Sets protocol type.
     *
     * @param protocolType the protocol type
     * @return the protocol type
     */
    public UrlInfo setProtocolType(string protocolType) {
        this.protocolType = protocolType;
        return this;
    }

    /**
     * Gets host.
     *
     * @return the host
     */
    public string getHost() {
        return host;
    }

    /**
     * Sets host.
     *
     * @param host the host
     * @return the host
     */
    public UrlInfo setHost(string host) {
        this.host = host;
        return this;
    }

    /**
     * Gets port.
     *
     * @return the port
     */
    public int getPort() {
        return port;
    }

    /**
     * Sets port.
     *
     * @param port the port
     * @return the port
     */
    public UrlInfo setPort(int port) {
        this.port = port;
        return this;
    }

    /**
     * Gets path.
     *
     * @return the path
     */
    public string getPath() {
        return path;
    }

    /**
     * Sets path.
     *
     * @param path the path
     * @return the path
     */
    public UrlInfo setPath(string path) {
        this.path = path;
        return this;
    }

    /**
     * Gets serialization type.
     *
     * @return the serialization type
     */
    public string getSerializationType() {
        return serializationType;
    }

    /**
     * Sets serialization type.
     *
     * @param serializationType the serialization type
     * @return the serialization type
     */
    public UrlInfo setSerializationType(string serializationType) {
        this.serializationType = serializationType;
        return this;
    }

    /**
     * Gets weight.
     *
     * @return the weight
     */
    public int getWeight() {
        // ProviderStatus status = getStatus();
        // if (status == ProviderStatus.WARMING_UP) {
        //     try {
        //         // 还处于预热时间中
        //         Integer warmUpWeight = cast(Integer) getDynamicAttr(UrlInfoAttrs.ATTR_WARMUP_WEIGHT);
        //         if (warmUpWeight !is null) {
        //             return warmUpWeight;
        //         }
        //     } catch (Exception e) {
        //         return weight;
        //     }
        // }
        return weight;
    }

    /**
     * Sets weight.
     *
     * @param weight the weight
     * @return the weight
     */
    public UrlInfo setWeight(int weight) {
        this.weight = weight;
        return this;
    }

    /**
     * Gets sofa version.
     *
     * @return the sofa version
     */
    public int getRpcVersion() {
        return rpcVersion;
    }

    /**
     * Sets sofa version.
     *
     * @param rpcVersion the sofa version
     * @return the sofa version
     */
    public UrlInfo setRpcVersion(int rpcVersion) {
        this.rpcVersion = rpcVersion;
        return this;
    }

    /**
     * Gets status.
     *
     * @return the status
     */
    // public ProviderStatus getStatus() {
    //     if (status == ProviderStatus.WARMING_UP) {
    //         if (System.currentTimeMillis() > (Long) getDynamicAttr(UrlInfoAttrs.ATTR_WARM_UP_END_TIME)) {
    //             // 如果已经过了预热时间，恢复为正常
    //             status = ProviderStatus.AVAILABLE;
    //             setDynamicAttr(UrlInfoAttrs.ATTR_WARM_UP_END_TIME, null);
    //         }
    //     }
    //     return status;
    // }

    /**
     * Sets status.
     *
     * @param status the status
     * @return the status
     */
    // public UrlInfo setStatus(ProviderStatus status) {
    //     this.status = status;
    //     return this;
    // }

    /**
     * Gets static attribute.
     *
     * @return the static attribute
     */
    public Map!(string, string) getStaticAttrs() {
        return staticAttrs;
    }

    /**
     * Sets static attribute.
     *
     * @param staticAttrs the static attribute
     * @return the static attribute
     */
    public UrlInfo setStaticAttrs(Map!(string, string) staticAttrs) {
        this.staticAttrs.clear();
        this.staticAttrs.putAll(staticAttrs);
        return this;
    }

    /**
     * Gets dynamic attribute.
     *
     * @return the dynamic attribute
     */
    public Map!(string, Object) getDynamicAttrs() {
        return dynamicAttrs;
    }

    /**
     * Sets dynamic attribute.
     *
     * @param dynamicAttrs the dynamic attribute
     * @return this
     */
    public UrlInfo setDynamicAttrs(Map!(string, Object) dynamicAttrs) {
        this.dynamicAttrs.clear();
        this.dynamicAttrs.putAll(dynamicAttrs);
        return this;
    }

    /**
     * gets static attribute.
     *
     * @param staticAttrKey the static attribute key
     * @return the static attribute Value
     */
    public string getStaticAttr(string staticAttrKey) {
        return staticAttrs.get(staticAttrKey);
    }

    /**
     * Sets static attribute.
     *
     * @param staticAttrKey   the static attribute key
     * @param staticAttrValue the static attribute value
     * @return the static attribute
     */
    public UrlInfo setStaticAttr(string staticAttrKey, string staticAttrValue) {
        if (staticAttrValue is null) {
            staticAttrs.remove(staticAttrKey);
        } else {
            staticAttrs.put(staticAttrKey, staticAttrValue);
        }
        return this;
    }

    /**
     * gets dynamic attribute.
     *
     * @param dynamicAttrKey the dynamic attribute key
     * @return the dynamic attribute Value
     */
    public Object getDynamicAttr(string dynamicAttrKey) {
        return dynamicAttrs.get(dynamicAttrKey);
    }

    /**
     * Sets dynamic attribute.
     *
     * @param dynamicAttrKey   the dynamic attribute key
     * @param dynamicAttrValue the dynamic attribute value
     * @return the dynamic attribute
     */
    public UrlInfo setDynamicAttr(string dynamicAttrKey, Object dynamicAttrValue) {
        if (dynamicAttrValue is null) {
            dynamicAttrs.remove(dynamicAttrKey);
        } else {
            dynamicAttrs.put(dynamicAttrKey, dynamicAttrValue);
        }
        return this;
    }

    override
    public string toString() {
        return originUrl is null ? host ~ ":" ~ port.to!string : originUrl;
    }

    /**
     * 得到属性值，先去动态属性，再取静态属性
     *
     * @param key 属性Key
     * @return 属性值
     */
    public string getAttr(string key) {
        string val =  dynamicAttrs.get(key).toString;
        return val is null ? staticAttrs.get(key) : val;
    }
}
