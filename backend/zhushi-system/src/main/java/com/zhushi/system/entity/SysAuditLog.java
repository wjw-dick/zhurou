package com.zhushi.system.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 审计日志（仅可查询）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_audit_log")
public class SysAuditLog extends BaseEntity {

    private Long userId;
    private String username;
    private String module;
    private String action;
    private String method;
    private String uri;
    private String params;
    private String result;
    private String ip;
    private String ua;
    private Long costMs;
    private Integer status;
    private String errorMsg;
}
