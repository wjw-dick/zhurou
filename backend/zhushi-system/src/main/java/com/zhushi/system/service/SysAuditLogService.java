package com.zhushi.system.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.system.entity.SysAuditLog;
import com.zhushi.system.mapper.SysAuditLogMapper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 * 审计日志服务：只写入与查询，不提供修改/删除入口
 */
@Service
public class SysAuditLogService extends ServiceImpl<SysAuditLogMapper, SysAuditLog> {

    @Async
    public void record(SysAuditLog log) {
        save(log);
    }
}
