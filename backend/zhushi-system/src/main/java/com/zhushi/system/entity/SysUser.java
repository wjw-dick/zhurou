package com.zhushi.system.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * 用户
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_user")
public class SysUser extends BaseEntity {

    private String username;

    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    private String nickname;
    private String realName;
    private String phone;
    private String email;
    private String avatar;
    private String userType;
    private Long storeId;

    /** 是否超级管理员：拥有全部功能维护权限 */
    private Integer isSuper;

    private Integer status;
    private LocalDateTime lastLoginTime;
    private String lastLoginIp;
    private String remark;

    /** 门店名称（非数据库字段） */
    @TableField(exist = false)
    private String storeName;

    /** 分配的角色（非数据库字段） */
    @TableField(exist = false)
    private java.util.List<Long> roleIds;
}
