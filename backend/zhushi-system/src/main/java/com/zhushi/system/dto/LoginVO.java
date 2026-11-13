package com.zhushi.system.dto;

import com.zhushi.common.security.LoginUser;
import lombok.Data;

import java.util.List;

@Data
public class LoginVO {

    private String token;
    private long expiresIn;
    private LoginUser userInfo;
    private List<String> roles;
    private List<String> perms;
}
