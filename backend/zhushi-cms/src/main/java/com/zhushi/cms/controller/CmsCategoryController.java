package com.zhushi.cms.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.cms.entity.CmsCategory;
import com.zhushi.cms.service.CmsCategoryService;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * CMS 栏目管理
 */
@Tag(name = "CMS栏目")
@RestController
@RequestMapping("/cms/category")
public class CmsCategoryController extends BaseController<CmsCategoryService, CmsCategory> {

    private final CmsCategoryService cmsCategoryService;

    public CmsCategoryController(CmsCategoryService cmsCategoryService, PermChecker permChecker) {
        super(permChecker);
        this.cmsCategoryService = cmsCategoryService;
    }

    @Override
    protected CmsCategoryService service() {
        return cmsCategoryService;
    }

    @Override
    protected String permPrefix() {
        return "cms:category";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name", "name_en", "code"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<CmsCategory> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByAsc("sort");
    }

    /** 启用栏目下拉 */
    @RequiresPerm("")
    @GetMapping("/options")
    public R<List<CmsCategory>> options() {
        return R.ok(cmsCategoryService.listEnabled());
    }
}
