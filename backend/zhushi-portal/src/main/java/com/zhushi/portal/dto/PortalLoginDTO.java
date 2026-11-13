package com.zhushi.portal.dto;

import lombok.Data;

/**
 * 微信登录入参（小程序 code 换取 openid 由前端/网关完成，此处接收已解密的身份）
 */
@Data
public class PortalLoginDTO {

    private String openid;
    private String unionid;
    private String nickname;
    private String avatar;
    private String phone;
    private Integer gender;
}
