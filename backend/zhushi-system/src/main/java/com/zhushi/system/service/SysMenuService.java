package com.zhushi.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.core.Constants;
import com.zhushi.common.security.LoginUser;
import com.zhushi.system.entity.SysMenu;
import com.zhushi.system.mapper.SysMenuMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 菜单服务：五套平台菜单查询 / 用户路由
 */
@Service
@RequiredArgsConstructor
public class SysMenuService extends ServiceImpl<SysMenuMapper, SysMenu> {

    /** 平台菜单列表 */
    public List<SysMenu> listByPlatform(String platform, boolean onlyVisible) {
        LambdaQueryWrapper<SysMenu> wrapper = new LambdaQueryWrapper<SysMenu>()
                .eq(SysMenu::getPlatform, platform)
                .orderByAsc(SysMenu::getSort).orderByAsc(SysMenu::getId);
        if (onlyVisible) {
            wrapper.eq(SysMenu::getVisible, 1);
        }
        return list(wrapper);
    }

    /** 当前用户在某平台的菜单（超管取全量） */
    public List<SysMenu> listUserMenus(LoginUser user, String platform) {
        if (user.isSuperAdmin()) {
            return listByPlatform(platform, false);
        }
        return baseMapper.selectMenusByUserId(user.getUserId(), platform);
    }

    /** 当前用户拥有的权限标识（超管返回 *:*:*） */
    public List<String> listUserPerms(LoginUser user) {
        if (user.isSuperAdmin()) {
            return List.of("*:*:*");
        }
        return baseMapper.selectMenusByUserId(user.getUserId(), Constants.PLATFORM_ADMIN).stream()
                .map(SysMenu::getPerm)
                .filter(p -> p != null && !p.isBlank())
                .distinct()
                .collect(java.util.stream.Collectors.toList());
    }
}
