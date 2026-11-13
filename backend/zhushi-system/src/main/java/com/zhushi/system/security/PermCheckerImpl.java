package com.zhushi.system.security;

import cn.hutool.core.util.StrUtil;
import com.zhushi.common.core.Constants;
import com.zhushi.common.security.LoginUser;
import com.zhushi.common.security.PermChecker;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.security.UserContext;
import org.springframework.stereotype.Component;

/**
 * 权限校验实现：超管拥有全部功能维护权限，一律放行。
 */
@Component
public class PermCheckerImpl implements PermChecker {

    @Override
    public boolean has(String perm) {
        LoginUser user = UserContext.get();
        if (user == null) {
            return false;
        }
        if (user.isSuperAdmin()) {
            return true;
        }
        if (StrUtil.isBlank(perm)) {
            return true;
        }
        return user.getPerms().contains(perm) || user.getPerms().contains("*:*:*");
    }

    @Override
    public void require(String perm) {
        if (!has(perm)) {
            throw BizException.noPerm("无权限执行该操作：" + perm);
        }
    }
}
