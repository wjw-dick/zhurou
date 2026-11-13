package com.zhushi.system.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.system.entity.SysI18n;
import com.zhushi.system.service.SysI18nService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@Tag(name = "多语言-词条")
@RestController
@RequestMapping("/system/i18n")
public class SysI18nController extends BaseController<SysI18nService, SysI18n> {

    private final SysI18nService i18nService;

    public SysI18nController(SysI18nService i18nService, PermChecker permChecker) {
        super(permChecker);
        this.i18nService = i18nService;
    }

    @Override
    protected SysI18nService service() {
        return i18nService;
    }

    @Override
    protected String permPrefix() {
        return "sys:i18n";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"i18n_key", "i18n_value"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SysI18n> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("langCode")), "lang_code", params.get("langCode"))
                .eq(StrUtil.isNotBlank(params.get("module")), "module", params.get("module"));
    }

    /** 语言包（前台运行时读取） */
    @RequiresPerm("")
    @GetMapping("/bundle/{langCode}")
    public R<Map<String, String>> bundle(@PathVariable String langCode) {
        return R.ok(i18nService.bundle(langCode));
    }
}
