package com.zhushi.system.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.system.entity.SysUser;
import com.zhushi.system.service.SysUserService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 用户管理（超管全量维护）
 */
@Tag(name = "用户管理")
@RestController
@RequestMapping("/system/user")
public class SysUserController extends BaseController<SysUserService, SysUser> {

    private final SysUserService userService;

    public SysUserController(SysUserService userService, PermChecker permChecker) {
        super(permChecker);
        this.userService = userService;
    }

    @Override
    protected SysUserService service() {
        return userService;
    }

    @Override
    protected String permPrefix() {
        return "sys:user";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"username", "nickname", "real_name", "phone"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SysUser> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("userType")), "user_type", params.get("userType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"));
    }

    @Override
    @OperationLog(module = "用户管理", action = "新增用户")
    @PostMapping
    public R<Long> save(@Valid @RequestBody SysUser user) {
        permChecker.require("sys:user:add");
        userService.createUser(user, user.getRoleIds());
        return R.ok(user.getId());
    }

    @Override
    @OperationLog(module = "用户管理", action = "编辑用户")
    @PutMapping
    public R<Void> update(@RequestBody SysUser user) {
        permChecker.require("sys:user:edit");
        userService.updateUser(user, user.getRoleIds());
        return R.ok();
    }

    @Override
    @OperationLog(module = "用户管理", action = "删除用户")
    @DeleteMapping("/{id}")
    public R<Void> remove(@PathVariable Long id) {
        permChecker.require("sys:user:del");
        userService.deleteUser(id);
        return R.ok();
    }

    @RequiresPerm("sys:user:list")
    @GetMapping("/{id}/roles")
    public R<List<Long>> roles(@PathVariable Long id) {
        return R.ok(userService.getRoleIds(id));
    }

    @OperationLog(module = "用户管理", action = "重置密码")
    @RequiresPerm("sys:user:resetPwd")
    @PutMapping("/{id}/resetPwd")
    public R<Void> resetPwd(@PathVariable Long id, @RequestParam(required = false) String password) {
        userService.resetPwd(id, password);
        return R.ok();
    }

    @RequiresPerm("sys:user:list")
    @GetMapping("/options")
    public R<List<SysUser>> options() {
        return R.ok(userService.list(new LambdaQueryWrapper<SysUser>()
                .eq(SysUser::getStatus, 1)
                .select(SysUser::getId, SysUser::getUsername, SysUser::getNickname, SysUser::getUserType)));
    }
}
