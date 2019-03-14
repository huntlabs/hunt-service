module hunt.service.util.CommonUtils;

import hunt.collection.List;
import std.exception;
import std.conv;

class CommonUtils
{
    static bool isNotEmpty(string str)
    {
        return (str !is null) && (str.length > 0);
    }

    /**
     * 字符串转数值
     *
     * @param num        数字
     * @param defaultInt 默认值
     * @return int
     */
    public static int parseInt(string num, int defaultInt) {
        if (num is null) {
            return defaultInt;
        } else {
            try {
                return to!int(num);
            } catch (Exception e) {
                return defaultInt;
            }
        }
    }
}