package com.zhushi.system.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.system.entity.SysMenu;
import com.zhushi.system.service.SysMenuService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 菜单维护（超管全量维护）：
 * 五套平台（ADMIN/PC/WECHAT/MINIAPP/H5）菜单树增删改 + 拖拽排序 + 图标 + 链接类型 + 显示开关
 */
@Tag(name = "菜单维护")
@RestController
@RequestMapping("/system/menu")
public class SysMenuController extends BaseController<SysMenuService, SysMenu> {

    private final SysMenuService menuService;

    public SysMenuController(SysMenuService menuService, PermChecker permChecker) {
        super(permChecker);
        this.menuService = menuService;
    }

    @Override
    protected SysMenuService service() {
        return menuService;
    }

    @Override
    protected String permPrefix() {
        return "sys:menu";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name", "path", "perm"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SysMenu> wrapper) {
        wrapper.eq(params.get("platform") != null && !params.get("platform").isBlank(),
                        "platform", params.get("platform"))
                .eq(params.get("menuType") != null && !params.get("menuType").isBlank(),
                        "menu_type", params.get("menuType"));
    }

    /** 某平台完整菜单树（含按钮），供菜单维护页左树使用 */
    @RequiresPerm("sys:menu:list")
    @GetMapping("/tree/{platform}")
    public R<List<SysMenu>> treeByPlatform(@PathVariable String platform) {
        return R.ok(menuService.listByPlatform(platform, false));
    }

    /** 拖拽排序 / 移动层级：[{id, parentId, sort}] */
    @OperationLog(module = "菜单维护", action = "拖拽排序")
    @RequiresPerm("sys:menu:sort")
    @PutMapping("/sort")
    public R<Void> sort(@RequestBody List<SysMenu> menus) {
        for (SysMenu menu : menus) {
            SysMenu update = new SysMenu();
            update.setId(menu.getId());
            update.setParentId(menu.getParentId() == null ? 0L : menu.getParentId());
            update.setSort(menu.getSort() == null ? 0 : menu.getSort());
            menuService.updateById(update);
        }
        return R.ok("排序已保存", null);
    }

    /** 服务端构建树（供角色授权选择） */
    @RequiresPerm("sys:menu:list")
    @GetMapping("/options")
    public R<List<SysMenu>> options(@RequestParam(defaultValue = "ADMIN") String platform) {
        return R.ok(com.zhushi.common.util.TreeUtil.build(menuService.listByPlatform(platform, false)));
    }
}
