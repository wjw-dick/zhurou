package com.zhushi.system.controller;

import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RateLimit;
import com.zhushi.common.annotation.RepeatSubmit;
import com.zhushi.common.core.Constants;
import com.zhushi.common.core.R;
import com.zhushi.common.security.LoginUser;
import com.zhushi.common.security.UserContext;
import com.zhushi.system.dto.LoginDTO;
import com.zhushi.system.dto.LoginVO;
import com.zhushi.system.dto.RouteVO;
import com.zhushi.system.service.AuthService;
import com.zhushi.system.service.SysI18nService;
import com.zhushi.system.service.SysMenuService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 认证 / 当前用户
 */
@Tag(name = "认证")
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;
    private final SysMenuService sysMenuService;
    private final SysI18nService sysI18nService;

    @OperationLog(module = "认证", action = "登录")
    @RateLimit(seconds = 60, count = 20, message = "登录过于频繁，请稍后再试")
    @Operation(summary = "登录")
    @PostMapping("/login")
    public R<LoginVO> login(@Valid @RequestBody LoginDTO dto, HttpServletRequest request) {
        return R.ok("登录成功", authService.login(dto, request));
    }

    @RepeatSubmit
    @OperationLog(module = "认证", action = "退出登录")
    @PostMapping("/logout")
    public R<Void> logout(@RequestHeader(value = Constants.HEADER_TOKEN, required = false) String token) {
        authService.logout(token);
        return R.ok();
    }

    @Operation(summary = "当前用户信息")
    @GetMapping("/info")
    public R<LoginUser> info() {
        return R.ok(UserContext.require());
    }

    @Operation(summary = "动态路由")
    @GetMapping("/routes")
    public R<List<RouteVO>> routes() {
        return R.ok(authService.routes(UserContext.require()));
    }

    @Operation(summary = "权限标识")
    @GetMapping("/perms")
    public R<List<String>> perms() {
        return R.ok(List.copyOf(UserContext.require().getPerms()));
    }

    @Operation(summary = "平台菜单（官网/公众号/小程序tabBar/H5）")
    @GetMapping("/menus/{platform}")
    public R<List<com.zhushi.system.entity.SysMenu>> menus(@PathVariable String platform) {
        return R.ok(sysMenuService.listByPlatform(platform, true));
    }

    @Operation(summary = "多语言词条包")
    @GetMapping("/i18n/{langCode}")
    public R<Map<String, String>> i18n(@PathVariable String langCode) {
        return R.ok(sysI18nService.bundle(langCode));
    }
}
