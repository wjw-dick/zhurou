package com.zhushi.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.system.entity.SysUser;
import com.zhushi.system.entity.SysUserRole;
import com.zhushi.system.mapper.SysUserMapper;
import com.zhushi.system.mapper.SysUserRoleMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 用户服务
 */
@Service
@RequiredArgsConstructor
public class SysUserService extends ServiceImpl<SysUserMapper, SysUser> {

    private final SysUserRoleMapper userRoleMapper;
    private final PasswordEncoder passwordEncoder;

    public SysUser getByUsername(String username) {
        return getOne(new LambdaQueryWrapper<SysUser>().eq(SysUser::getUsername, username), false);
    }

    public List<Long> getRoleIds(Long userId) {
        return userRoleMapper.selectList(new LambdaQueryWrapper<SysUserRole>().eq(SysUserRole::getUserId, userId))
                .stream().map(SysUserRole::getRoleId).collect(Collectors.toList());
    }

    @Transactional(rollbackFor = Exception.class)
    public void createUser(SysUser user, List<Long> roleIds) {
        if (getByUsername(user.getUsername()) != null) {
            throw new BizException("账号已存在");
        }
        String raw = StringUtils.hasText(user.getPassword()) ? user.getPassword() : "123456";
        user.setPassword(passwordEncoder.encode(raw));
        if (user.getIsSuper() == null) {
            user.setIsSuper(0);
        }
        save(user);
        saveRoles(user.getId(), roleIds);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateUser(SysUser user, List<Long> roleIds) {
        SysUser exist = getById(user.getId());
        if (exist == null) {
            throw new BizException("用户不存在");
        }
        // 密码不通过编辑接口修改
        user.setPassword(null);
        user.setUsername(null);
        updateById(user);
        userRoleMapper.delete(new LambdaQueryWrapper<SysUserRole>().eq(SysUserRole::getUserId, user.getId()));
        saveRoles(user.getId(), roleIds);
    }

    private void saveRoles(Long userId, List<Long> roleIds) {
        if (roleIds == null || roleIds.isEmpty()) {
            return;
        }
        for (Long roleId : roleIds) {
            SysUserRole ur = new SysUserRole();
            ur.setUserId(userId);
            ur.setRoleId(roleId);
            userRoleMapper.insert(ur);
        }
    }

    public void resetPwd(Long userId, String newPwd) {
        SysUser user = new SysUser();
        user.setId(userId);
        user.setPassword(passwordEncoder.encode(StringUtils.hasText(newPwd) ? newPwd : "123456"));
        updateById(user);
    }

    @Transactional(rollbackFor = Exception.class)
    public void deleteUser(Long userId) {
        SysUser user = getById(userId);
        if (user != null && Integer.valueOf(1).equals(user.getIsSuper())) {
            throw new BizException("超级管理员不可删除");
        }
        removeById(userId);
        userRoleMapper.delete(new LambdaQueryWrapper<SysUserRole>().eq(SysUserRole::getUserId, userId));
    }
}
