package com.zhushi.common.aspect;

import com.zhushi.common.annotation.RateLimit;
import com.zhushi.common.core.Constants;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.security.UserContext;
import cn.hutool.extra.servlet.JakartaServletUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.time.Duration;

/**
 * 接口限流切面
 */
@Aspect
@Component
@RequiredArgsConstructor
public class RateLimitAspect {

    private final StringRedisTemplate stringRedisTemplate;

    @Around("@annotation(rateLimit)")
    public Object around(ProceedingJoinPoint point, RateLimit rateLimit) throws Throwable {
        String identity;
        if ("USER".equalsIgnoreCase(rateLimit.type())) {
            Long userId = UserContext.userId();
            identity = "u:" + userId;
        } else {
            ServletRequestAttributes attributes =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            HttpServletRequest request = attributes == null ? null : attributes.getRequest();
            identity = "ip:" + (request == null ? "unknown" : JakartaServletUtil.getClientIP(request));
        }
        String key = Constants.RATE_LIMIT_PREFIX
                + point.getSignature().toShortString() + ":" + identity;
        Long count = stringRedisTemplate.opsForValue().increment(key);
        if (count != null && count == 1L) {
            stringRedisTemplate.expire(key, Duration.ofSeconds(rateLimit.seconds()));
        }
        if (count != null && count > rateLimit.count()) {
            throw new BizException(429, rateLimit.message());
        }
        return point.proceed();
    }
}
