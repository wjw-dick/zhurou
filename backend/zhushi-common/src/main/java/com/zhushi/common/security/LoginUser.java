package com.zhushi.common.security;

import lombok.Data;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

/**
 * 登录用户上下文信息（存 Redis，随 token 读取）
 */
@Data
public class LoginUser implements Serializable {

    private Long userId;
    private String username;
    private String nickname;
    private String avatar;
    private String userType;
    /** 是否超级管理员：拥有全部功能维护权限 */
    private boolean superAdmin;
    /** 关联门店（店长/店员） */
    private Long storeId;
    /** 关联供应商 / 渠道商 ID */
    private Long supplierId;
    private Long channelId;
    /** 门店名称（冗余展示用） */
    private String storeName;
    private Set<String> roles = new HashSet<>();
    private Set<String> perms = new HashSet<>();
}
