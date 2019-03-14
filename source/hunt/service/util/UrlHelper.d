module hunt.service.util.UrlHelper;

import hunt.service.util.UrlInfo;
import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.Exceptions;
import hunt.text.StringBuilder;
import std.string;
import std.conv;
import hunt.text.Common;
import hunt.text.StringUtils;
import hunt.service.util.CommonUtils;


enum UrlInfoAttrs
{
    ATTR_RPC_VERSION = "rpcVer",
    ATTR_SERIALIZATION = "serialization",
    ATTR_WEIGHT = "weight",
}

public class UrlHelper {
    

    /**
     * Compare two provider list, return add list and remove list
     *
     * @param oldList old Provider list
     * @param newList new provider list
     * @param add     provider list need add
     * @param remove  provider list need remove
     */
    // public static void compareProviders(List!(UrlInfo) oldList, List!(UrlInfo) newList,
    //                                     List!(UrlInfo) add, List!(UrlInfo) remove) {
    //     // 比较老列表和当前列表
    //     if (oldList is null || oldList.size == 0) {
    //         // 空变成非空
    //         if (newList !is null) {
    //             add.addAll(newList);
    //         }
    //         // 空到空，忽略
    //     } else {
    //         // 非空变成空
    //         if (newList is null || newList.size == 0) {
    //             remove.addAll(oldList);
    //         } else {
    //             // 非空变成非空，比较
    //             if (oldList !is null) {
    //                 List!(UrlInfo) tmpList = new ArrayList!(UrlInfo)();
    //                 foreach(value; newList) {
    //                     tmpList.add(value);
    //                 }
    //                 // 遍历老的
    //                 foreach (UrlInfo oldProvider ; oldList) {
    //                     if (tmpList.contains(oldProvider)) {
    //                         tmpList.remove(oldProvider);
    //                     } else {
    //                         // 新的没有，老的有，删掉
    //                         remove.add(oldProvider);
    //                     }
    //                 }
    //                 add.addAll(tmpList);
    //             }
    //         }
    //     }
    // }
    
    /**
     * Write provider info to url string
     * 
     * @param providerInfo Provide info
     * @return the string
     */
    public static string toUrl(UrlInfo providerInfo) {
        string uri = providerInfo.getProtocolType() ~ "://" ~ providerInfo.getHost().to!string ~ ":" ~ providerInfo.getPort().to!string;
        uri ~= strip(providerInfo.getPath());
        StringBuilder sb = new StringBuilder();
        if (providerInfo.getRpcVersion() > 0) {
            sb.append("&").append(UrlInfoAttrs.ATTR_RPC_VERSION).append("=").append(providerInfo.getRpcVersion());
        }
        if (providerInfo.getSerializationType() != null) {
            sb.append("&").append(UrlInfoAttrs.ATTR_SERIALIZATION).append("=")
                .append(providerInfo.getSerializationType());
        }
        foreach(string k , string v ; providerInfo.getStaticAttrs()) {
            sb.append("&").append(k).append("=").append(v);
        }
        if (sb.length() > 0) {
            uri ~= sb.replace(0, 1, "?").toString();
        }
        return uri;
    }

    /**
     * Parse url string to UrlInfo.
     *
     * @param url the url
     * @return UrlInfo 
     */
    public static UrlInfo toProviderInfo(string url) {
        UrlInfo providerInfo = new UrlInfo();
        providerInfo.setOriginUrl(url);
        try {
            int protocolIndex = cast(int)(url.indexOf("://"));
            string remainUrl;
            if (protocolIndex > -1) {
                string protocol = url.substring(0, protocolIndex).toLower();
                providerInfo.setProtocolType(protocol);
                remainUrl = url.substring(protocolIndex + 3);
            } else { // 默认
                remainUrl = url;
            }

            int addressIndex = cast(int)(remainUrl.indexOf("/"));
            string address;
            if (addressIndex > -1) {
                address = remainUrl.substring(0, addressIndex);
                remainUrl = remainUrl.substring(addressIndex);
            } else {
                int itfIndex = cast(int)(remainUrl.indexOf('?'));
                if (itfIndex > -1) {
                    address = remainUrl.substring(0, itfIndex);
                    remainUrl = remainUrl.substring(itfIndex);
                } else {
                    address = remainUrl;
                    remainUrl = "";
                }
            }
            string[] ipAndPort = StringUtils.split(address,":", -1); // TODO 不支持ipv6
            providerInfo.setHost(ipAndPort[0]);
            if (ipAndPort.length > 1) {
                providerInfo.setPort(CommonUtils.parseInt(ipAndPort[1], providerInfo.getPort()));
            }

            // 后面可以解析remainUrl得到interface等 /xxx?a=1&b=2
            if (remainUrl.length > 0) {
                int itfIndex = cast(int)(remainUrl.indexOf('?'));
                if (itfIndex > -1) {
                    string itf = remainUrl.substring(0, itfIndex);
                    providerInfo.setPath(itf);
                    // 剩下是params,例如a=1&b=2
                    remainUrl = remainUrl.substring(itfIndex + 1);
                    string[] params = StringUtils.split(remainUrl,"&", -1);
                    foreach (string parm ; params) {
                        string[] kvpair = StringUtils.split(parm,"=", -1);
                        if (UrlInfoAttrs.ATTR_WEIGHT.equals(kvpair[0]) && CommonUtils.isNotEmpty(kvpair[1])) {
                            int weight = CommonUtils.parseInt(kvpair[1], providerInfo.getWeight());
                            providerInfo.setWeight(weight);
                            providerInfo.setStaticAttr(UrlInfoAttrs.ATTR_WEIGHT, to!string(weight));
                        } else if (UrlInfoAttrs.ATTR_RPC_VERSION == kvpair[0] && CommonUtils.isNotEmpty(kvpair[1])) {
                            providerInfo.setRpcVersion(CommonUtils.parseInt(kvpair[1], providerInfo.getRpcVersion()));
                        } else if (UrlInfoAttrs.ATTR_SERIALIZATION == kvpair[0] &&
                            CommonUtils.isNotEmpty(kvpair[1])) {
                            providerInfo.setSerializationType(kvpair[1]);
                        } else {
                            providerInfo.getStaticAttrs().put(kvpair[0], kvpair[1]);
                        }

                    }
                } else {
                    providerInfo.setPath(remainUrl);
                }
            } else {
                providerInfo.setPath("");
            }
        } catch (Exception e) {
            throw new IllegalArgumentException("Failed to convert url to provider, the wrong url is:" ~ url, e);
        }
        return providerInfo;
    }
}
