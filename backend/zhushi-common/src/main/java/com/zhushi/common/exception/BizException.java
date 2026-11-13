package com.zhushi.common.exception;

import lombok.Getter;

/**
 * 业务异常
 */
@Getter
public class BizException extends RuntimeException {

    private final int code;

    public BizException(String message) {
        super(message);
        this.code = 500;
    }

    public BizException(int code, String message) {
        super(message);
        this.code = code;
    }

    public static BizException of(String message) {
        return new BizException(message);
    }

    public static BizException noAuth(String message) {
        return new BizException(401, message);
    }

    public static BizException noPerm(String message) {
        return new BizException(403, message);
    }
}
