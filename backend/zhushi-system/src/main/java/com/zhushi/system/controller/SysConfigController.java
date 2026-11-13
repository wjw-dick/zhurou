package com.zhushi.system.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.system.entity.SysConfig;
import com.zhushi.system.service.SysConfigService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 系统参数可视化配置（超管全量维护）
 */
@Tag(name = "系统参数")
@RestController
@RequestMapping("/system/config")
public class SysConfigController extends BaseController<SysConfigService, SysConfig> {

    private final SysConfigService configService;

    public SysConfigController(SysConfigService configService, PermChecker permChecker) {
        super(permChecker);
        this.configService = configService;
    }

    @Override
    protected SysConfigService service() {
        return configService;
    }

    @Override
    protected String permPrefix() {
        return "sys:config";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"config_key", "config_name"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SysConfig> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("groupCode")), "group_code", params.get("groupCode"));
    }

    /** 分组表单 */
    @RequiresPerm("sys:config:list")
    @GetMapping("/grouped")
    public R<Map<String, List<SysConfig>>> grouped() {
        return R.ok(configService.grouped());
    }

    /** 全部键值（前端运行时读取） */
    @RequiresPerm("sys:config:list")
    @GetMapping("/kv")
    public R<Map<String, String>> kv() {
        return R.ok(configService.kv());
    }

    /** 批量保存分组配置 */
    @OperationLog(module = "系统参数", action = "批量保存")
    @RequiresPerm("sys:config:edit")
    @PutMapping("/batch")
    public R<Void> saveBatch(@RequestBody List<Map<String, Object>> items) {
        configService.saveBatchValues(items);
        return R.ok("保存成功", null);
    }
}
