package com.zhushi.system.security;

import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.security.PermChecker;
import lombok.RequiredArgsConstructor;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

/**
 * 权限注解切面
 */
@Aspect
@Component
@RequiredArgsConstructor
public class PermAspect {

    private final PermChecker permChecker;

    @Before("@annotation(requiresPerm)")
    public void check(RequiresPerm requiresPerm) {
        permChecker.require(requiresPerm.value());
    }
}
