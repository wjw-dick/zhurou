package com.zhushi.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 操作审计注解：标注后自动写入 sys_audit_log（仅记录，不提供修改入口）
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface OperationLog {

    /** 模块名 */
    String module() default "";

    /** 操作类型 */
    String action() default "";

    /** 是否记录请求参数 */
    boolean saveParams() default true;
}
