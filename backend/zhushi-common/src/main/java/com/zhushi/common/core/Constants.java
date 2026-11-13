package com.zhushi.common.core;

/**
 * 全局常量
 */
public interface Constants {

    /** 超级管理员标记：拥有全部功能维护权限 */
    Integer SUPER_ADMIN_YES = 1;

    /** 登录会话 Redis 前缀 */
    String LOGIN_TOKEN_PREFIX = "zhushi:login:token:";
    /** 登录用户信息 Redis 前缀 */
    String LOGIN_USER_PREFIX = "zhushi:login:user:";
    /** 请求防重前缀 */
    String REPEAT_SUBMIT_PREFIX = "zhushi:repeat:";
    /** 限流前缀 */
    String RATE_LIMIT_PREFIX = "zhushi:rate:";
    /** 鲜肉预订库存锁前缀 */
    String RESERVE_LOCK_PREFIX = "zhushi:reserve:lock:";

    /** 请求头 */
    String HEADER_TOKEN = "Authorization";
    String TOKEN_PREFIX = "Bearer ";

    /** 运行平台 */
    String PLATFORM_ADMIN = "ADMIN";
    String PLATFORM_PC = "PC";
    String PLATFORM_WECHAT = "WECHAT";
    String PLATFORM_MINIAPP = "MINIAPP";
    String PLATFORM_H5 = "H5";

    /** 树根节点 */
    Long TREE_ROOT = 0L;
}
