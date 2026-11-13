package com.zhushi.common.security;

/**
 * 权限校验器：由 system 模块实现。
 * 超管(LoginUser.superAdmin)拥有全部功能维护权限，一律放行。
 */
public interface PermChecker {

    /** 当前用户是否拥有某权限 */
    boolean has(String perm);

    /** 没有该权限则抛出 403 */
    void require(String perm);
}
