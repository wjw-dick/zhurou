package com.zhushi.system.service;

import cn.hutool.core.util.IdUtil;
import cn.hutool.extra.servlet.JakartaServletUtil;
import com.zhushi.common.core.Constants;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.security.JwtUtil;
import com.zhushi.common.security.LoginUser;
import com.zhushi.system.dto.LoginDTO;
import com.zhushi.system.dto.LoginVO;
import com.zhushi.system.dto.RouteVO;
import com.zhushi.system.entity.SysMenu;
import com.zhushi.system.entity.SysUser;
import com.zhushi.system.mapper.SysUserMapper;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 登录认证服务
 */
@Service
@RequiredArgsConstructor
public class AuthService {

    private final SysUserService sysUserService;
    private final SysUserMapper sysUserMapper;
    private final SysMenuService sysMenuService;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final RedisTemplate<String, Object> redisTemplate;

    @Transactional(rollbackFor = Exception.class)
    public LoginVO login(LoginDTO dto, HttpServletRequest request) {
        SysUser user = sysUserService.getByUsername(dto.getUsername());
        if (user == null) {
            throw new BizException("账号或密码错误");
        }
        if (!passwordEncoder.matches(dto.getPassword(), user.getPassword())) {
            throw new BizException("账号或密码错误");
        }
        if (!Integer.valueOf(1).equals(user.getStatus())) {
            throw new BizException("账号已被禁用，请联系管理员");
        }

        LoginUser loginUser = new LoginUser();
        loginUser.setUserId(user.getId());
        loginUser.setUsername(user.getUsername());
        loginUser.setNickname(user.getNickname());
        loginUser.setAvatar(user.getAvatar());
        loginUser.setUserType(user.getUserType());
        loginUser.setStoreId(user.getStoreId());
        loginUser.setSuperAdmin(Integer.valueOf(1).equals(user.getIsSuper()));
        loginUser.setRoles(new java.util.HashSet<>(sysUserMapper.selectRoleCodesByUserId(user.getId())));
        if (loginUser.isSuperAdmin()) {
            loginUser.setPerms(new java.util.HashSet<>(List.of("*:*:*")));
        } else {
            loginUser.setPerms(new java.util.HashSet<>(sysUserMapper.selectPermsByUserId(user.getId())));
        }

        String sessionId = IdUtil.fastSimpleUUID();
        redisTemplate.opsForValue().set(Constants.LOGIN_USER_PREFIX + sessionId, loginUser,
                Duration.ofHours(jwtUtil.getExpireHours()));
        String token = jwtUtil.create(sessionId, user.getId());

        SysUser update = new SysUser();
        update.setId(user.getId());
        update.setLastLoginTime(LocalDateTime.now());
        update.setLastLoginIp(JakartaServletUtil.getClientIP(request));
        sysUserService.updateById(update);

        LoginVO vo = new LoginVO();
        vo.setToken(token);
        vo.setExpiresIn(jwtUtil.getExpireHours() * 3600);
        vo.setUserInfo(loginUser);
        vo.setRoles(List.copyOf(loginUser.getRoles()));
        vo.setPerms(List.copyOf(loginUser.getPerms()));
        return vo;
    }

    public void logout(String token) {
        if (token == null) {
            return;
        }
        if (token.startsWith(Constants.TOKEN_PREFIX)) {
            token = token.substring(Constants.TOKEN_PREFIX.length());
        }
        String sessionId = jwtUtil.parseSessionId(token);
        if (sessionId != null) {
            redisTemplate.delete(Constants.LOGIN_USER_PREFIX + sessionId);
        }
    }

    /** 当前用户后台动态路由 */
    public List<RouteVO> routes(LoginUser loginUser) {
        List<SysMenu> menus = sysMenuService.listUserMenus(loginUser, Constants.PLATFORM_ADMIN);
        List<RouteVO> routes = menus.stream()
                .filter(m -> !"BUTTON".equals(m.getMenuType()))
                .filter(m -> m.getParentId() == null || m.getParentId() == 0L)
                .sorted(java.util.Comparator.comparing(m -> m.getSort() == null ? 0 : m.getSort()))
                .map(m -> toRoute(m, menus))
                .collect(java.util.stream.Collectors.toList());
        return routes;
    }

    private RouteVO toRoute(SysMenu menu, List<SysMenu> all) {
        RouteVO route = new RouteVO();
        route.setId(menu.getId());
        route.setName(menu.getPath());
        route.setPath(menu.getPath());
        route.setComponent(menu.getComponent());
        route.getMeta().setTitle(menu.getName());
        route.getMeta().setTitleEn(menu.getNameEn());
        route.getMeta().setIcon(menu.getIcon());
        route.getMeta().setPerm(menu.getPerm());
        route.getMeta().setHidden(Integer.valueOf(0).equals(menu.getVisible()));
        route.getMeta().setKeepAlive(!Integer.valueOf(0).equals(menu.getKeepAlive()));
        List<RouteVO> children = all.stream()
                .filter(c -> menu.getId().equals(c.getParentId()))
                .filter(c -> !"BUTTON".equals(c.getMenuType()))
                .sorted(java.util.Comparator.comparing(c -> c.getSort() == null ? 0 : c.getSort()))
                .map(c -> toRoute(c, all))
                .collect(java.util.stream.Collectors.toList());
        route.setChildren(children);
        return route;
    }
}
