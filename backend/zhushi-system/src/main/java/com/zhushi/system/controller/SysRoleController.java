package com.zhushi.system.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.system.entity.SysRole;
import com.zhushi.system.service.SysRoleService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 角色管理（超管全量维护）
 */
@Tag(name = "角色管理")
@RestController
@RequestMapping("/system/role")
public class SysRoleController extends BaseController<SysRoleService, SysRole> {

    private final SysRoleService roleService;

    public SysRoleController(SysRoleService roleService, PermChecker permChecker) {
        super(permChecker);
        this.roleService = roleService;
    }

    @Override
    protected SysRoleService service() {
        return roleService;
    }

    @Override
    protected String permPrefix() {
        return "sys:role";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"code", "name"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SysRole> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("platform")), "platform", params.get("platform"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"));
    }

    @OperationLog(module = "角色管理", action = "分配权限")
    @RequiresPerm("sys:role:assign")
    @PutMapping("/{id}/menus")
    public R<Void> assignMenus(@PathVariable Long id, @RequestBody List<Long> menuIds) {
        roleService.assignMenus(id, menuIds);
        return R.ok("权限分配成功", null);
    }

    @RequiresPerm("sys:role:list")
    @GetMapping("/{id}/menus")
    public R<List<Long>> menus(@PathVariable Long id) {
        return R.ok(roleService.getMenuIds(id));
    }

    @RequiresPerm("sys:role:list")
    @GetMapping("/options")
    public R<List<SysRole>> options() {
        return R.ok(roleService.list(new QueryWrapper<SysRole>().eq("status", 1).orderByAsc("sort")));
    }
}
