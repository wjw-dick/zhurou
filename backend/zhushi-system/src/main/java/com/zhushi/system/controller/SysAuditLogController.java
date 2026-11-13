package com.zhushi.system.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.security.PermChecker;
import com.zhushi.system.entity.SysAuditLog;
import com.zhushi.system.service.SysAuditLogService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 审计日志：仅可查询，不可增删改（含超管）
 */
@Tag(name = "审计日志")
@RestController
@RequestMapping("/system/audit")
public class SysAuditLogController extends BaseController<SysAuditLogService, SysAuditLog> {

    private final SysAuditLogService auditLogService;

    public SysAuditLogController(SysAuditLogService auditLogService, PermChecker permChecker) {
        super(permChecker);
        this.auditLogService = auditLogService;
    }

    @Override
    protected SysAuditLogService service() {
        return auditLogService;
    }

    @Override
    protected String permPrefix() {
        return "sys:audit";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"username", "module", "action", "uri"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SysAuditLog> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .eq(StrUtil.isNotBlank(params.get("username")), "username", params.get("username"))
                .ge(StrUtil.isNotBlank(params.get("startTime")), "create_time", params.get("startTime"))
                .le(StrUtil.isNotBlank(params.get("endTime")), "create_time", params.get("endTime"))
                .orderByDesc("create_time");
    }

    @Override
    @PostMapping
    public R<Long> save(@RequestBody SysAuditLog entity) {
        throw new BizException("审计日志不可新增");
    }

    @Override
    @PutMapping
    public R<Void> update(@RequestBody SysAuditLog entity) {
        throw new BizException("审计日志不可修改");
    }

    @Override
    @DeleteMapping("/{id}")
    public R<Void> remove(@PathVariable Long id) {
        throw new BizException("审计日志不可删除");
    }

    @Override
    @DeleteMapping("/batch")
    public R<Void> removeBatch(@RequestBody List<Long> ids) {
        throw new BizException("审计日志不可删除");
    }
}
