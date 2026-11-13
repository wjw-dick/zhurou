package com.zhushi.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 接口限流（Redis 计数器）
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface RateLimit {

    /** 时间窗口秒数 */
    int seconds() default 60;

    /** 窗口内最大请求次数 */
    int count() default 60;

    /** 限流维度：IP / USER */
    String type() default "IP";

    String message() default "操作过于频繁，请稍后再试";
}
