package com.zhushi.common.aspect;

import cn.hutool.crypto.digest.DigestUtil;
import com.zhushi.common.annotation.RepeatSubmit;
import com.zhushi.common.core.Constants;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.security.UserContext;
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
 * 防重复提交切面
 */
@Aspect
@Component
@RequiredArgsConstructor
public class RepeatSubmitAspect {

    private final StringRedisTemplate stringRedisTemplate;

    @Around("@annotation(repeatSubmit)")
    public Object around(ProceedingJoinPoint point, RepeatSubmit repeatSubmit) throws Throwable {
        ServletRequestAttributes attributes =
                (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes == null ? null : attributes.getRequest();
        String uri = request == null ? "" : request.getRequestURI();
        Long userId = UserContext.userId();
        String raw = uri + "|" + userId + "|" + DigestUtil.md5Hex(String.valueOf(point.getArgs()));
        String key = Constants.REPEAT_SUBMIT_PREFIX + DigestUtil.md5Hex(raw);
        Boolean ok = stringRedisTemplate.opsForValue()
                .setIfAbsent(key, "1", Duration.ofSeconds(repeatSubmit.interval()));
        if (Boolean.FALSE.equals(ok)) {
            throw new BizException(repeatSubmit.message());
        }
        return point.proceed();
    }
}
