package com.zhushi.system.security;

import cn.hutool.extra.servlet.JakartaServletUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.security.LoginUser;
import com.zhushi.common.security.UserContext;
import com.zhushi.system.entity.SysAuditLog;
import com.zhushi.system.service.SysAuditLogService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;
import java.util.stream.Collectors;

/**
 * 操作审计切面：全操作留痕（仅记录，不提供修改入口）
 * 覆盖两类接口：
 * 1) 显式标注 {@link OperationLog} 的接口（业务语义更清晰）
 * 2) 其余所有写操作（POST/PUT/DELETE）
 */
@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class AuditAspect {

    private final SysAuditLogService auditLogService;
    private final ObjectMapper objectMapper;

    @Around("@annotation(operationLog)")
    public Object aroundAnnotated(ProceedingJoinPoint point, OperationLog operationLog) throws Throwable {
        return record(point, operationLog.module(), operationLog.action(), operationLog.saveParams());
    }

    @Around("execution(* com.zhushi..controller..*(..)) "
            + "&& (@annotation(org.springframework.web.bind.annotation.PostMapping) "
            + "|| @annotation(org.springframework.web.bind.annotation.PutMapping) "
            + "|| @annotation(org.springframework.web.bind.annotation.DeleteMapping)) "
            + "&& !@annotation(com.zhushi.common.annotation.OperationLog)")
    public Object aroundWrite(ProceedingJoinPoint point) throws Throwable {
        String module = point.getTarget().getClass().getSimpleName().replace("Controller", "");
        String action = point.getSignature().getName();
        return record(point, module, action, true);
    }

    private Object record(ProceedingJoinPoint point, String module, String action, boolean saveParams) throws Throwable {
        long start = System.currentTimeMillis();
        Object result = null;
        Throwable error = null;
        try {
            result = point.proceed();
            return result;
        } catch (Throwable e) {
            error = e;
            throw e;
        } finally {
            try {
                write(point, module, action, saveParams, result, error, System.currentTimeMillis() - start);
            } catch (Exception e) {
                log.warn("审计日志写入失败：{}", e.getMessage());
            }
        }
    }

    private void write(ProceedingJoinPoint point, String module, String action, boolean saveParams,
                       Object result, Throwable error, long cost) {
        ServletRequestAttributes attributes =
                (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes == null ? null : attributes.getRequest();

        SysAuditLog record = new SysAuditLog();
        LoginUser user = UserContext.get();
        if (user != null) {
            record.setUserId(user.getUserId());
            record.setUsername(user.getUsername());
        }
        record.setModule(module);
        record.setAction(action);
        record.setCostMs(cost);
        record.setStatus(error == null ? 1 : 0);
        if (request != null) {
            record.setMethod(request.getMethod());
            record.setUri(request.getRequestURI());
            record.setIp(JakartaServletUtil.getClientIP(request));
            record.setUa(request.getHeader("User-Agent"));
        }
        if (saveParams) {
            record.setParams(serialize(point.getArgs()));
        }
        if (error != null) {
            record.setErrorMsg(error.getMessage());
        } else if (result != null) {
            record.setResult(serialize(result));
        }
        auditLogService.record(record);
    }

    private String serialize(Object value) {
        try {
            String text;
            if (value instanceof Object[] args) {
                text = Arrays.stream(args)
                        .filter(a -> !(a instanceof MultipartFile))
                        .filter(a -> !(a instanceof jakarta.servlet.ServletRequest))
                        .filter(a -> !(a instanceof jakarta.servlet.ServletResponse))
                        .map(a -> {
                            try {
                                return objectMapper.writeValueAsString(a);
                            } catch (Exception e) {
                                return String.valueOf(a);
                            }
                        }).collect(Collectors.joining(","));
            } else {
                text = objectMapper.writeValueAsString(value);
            }
            return text.length() > 2000 ? text.substring(0, 2000) : text;
        } catch (Exception e) {
            return null;
        }
    }
}
