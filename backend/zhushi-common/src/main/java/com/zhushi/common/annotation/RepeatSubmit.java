package com.zhushi.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 接口防重提交（Redis）
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface RepeatSubmit {

    /** 间隔秒数 */
    long interval() default 3;

    /** 提示语 */
    String message() default "请勿重复提交，请稍后再试";
}
