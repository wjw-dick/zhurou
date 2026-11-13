package com.zhushi.common.security;

import com.zhushi.common.exception.BizException;

/**
 * 当前登录用户上下文（ThreadLocal）
 */
public class UserContext {

    private static final ThreadLocal<LoginUser> HOLDER = new ThreadLocal<>();

    public static void set(LoginUser user) {
        HOLDER.set(user);
    }

    public static LoginUser get() {
        return HOLDER.get();
    }

    public static LoginUser require() {
        LoginUser user = HOLDER.get();
        if (user == null) {
            throw BizException.noAuth("登录已过期，请重新登录");
        }
        return user;
    }

    public static Long userId() {
        LoginUser user = HOLDER.get();
        return user == null ? null : user.getUserId();
    }

    public static boolean isSuperAdmin() {
        LoginUser user = HOLDER.get();
        return user != null && user.isSuperAdmin();
    }

    public static void clear() {
        HOLDER.remove();
    }
}
