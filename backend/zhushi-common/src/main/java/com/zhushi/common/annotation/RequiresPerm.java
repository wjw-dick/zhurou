package com.zhushi.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 接口权限标识。要求当前用户具备指定权限；超管自动放行。
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface RequiresPerm {

    /** 权限标识，如 sys:user:add；为空时按 value 数组任一即可 */
    String value() default "";

    /** true=拥有任一即可 */
    boolean anyOf() default true;
}
