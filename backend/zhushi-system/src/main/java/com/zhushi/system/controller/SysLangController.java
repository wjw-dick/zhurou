package com.zhushi.system.controller;

import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.system.entity.SysLang;
import com.zhushi.system.service.SysLangService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "多语言-语言")
@RestController
@RequestMapping("/system/lang")
public class SysLangController extends BaseController<SysLangService, SysLang> {

    private final SysLangService langService;

    public SysLangController(SysLangService langService, PermChecker permChecker) {
        super(permChecker);
        this.langService = langService;
    }

    @Override
    protected SysLangService service() {
        return langService;
    }

    @Override
    protected String permPrefix() {
        return "sys:i18n";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"code", "name"};
    }
}
