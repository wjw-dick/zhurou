package com.zhushi.system.security;

import cn.hutool.core.util.StrUtil;
import com.zhushi.common.core.Constants;
import com.zhushi.common.security.JwtUtil;
import com.zhushi.common.security.LoginUser;
import com.zhushi.common.security.UserContext;
import com.zhushi.common.exception.BizException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 登录拦截器：JWT + Redis 会话
 */
@Component
@RequiredArgsConstructor
public class AuthInterceptor implements HandlerInterceptor {

    private final JwtUtil jwtUtil;
    private final RedisTemplate<String, Object> redisTemplate;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }
        String token = request.getHeader(Constants.HEADER_TOKEN);
        if (StrUtil.isBlank(token)) {
            token = request.getParameter("token");
        }
        if (StrUtil.isBlank(token)) {
            throw BizException.noAuth("未登录或登录已过期");
        }
        if (token.startsWith(Constants.TOKEN_PREFIX)) {
            token = token.substring(Constants.TOKEN_PREFIX.length());
        }
        String sessionId = jwtUtil.parseSessionId(token);
        if (StrUtil.isBlank(sessionId)) {
            throw BizException.noAuth("登录已过期，请重新登录");
        }
        Object cached = redisTemplate.opsForValue().get(Constants.LOGIN_USER_PREFIX + sessionId);
        if (cached == null) {
            throw BizException.noAuth("登录已过期，请重新登录");
        }
        UserContext.set((LoginUser) cached);
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                                Object handler, Exception ex) {
        UserContext.clear();
    }
}
