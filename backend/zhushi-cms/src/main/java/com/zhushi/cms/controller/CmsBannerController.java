package com.zhushi.cms.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.cms.entity.CmsBanner;
import com.zhushi.cms.service.CmsBannerService;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * Banner 管理
 */
@Tag(name = "Banner管理")
@RestController
@RequestMapping("/cms/banner")
public class CmsBannerController extends BaseController<CmsBannerService, CmsBanner> {

    private final CmsBannerService cmsBannerService;

    public CmsBannerController(CmsBannerService cmsBannerService, PermChecker permChecker) {
        super(permChecker);
        this.cmsBannerService = cmsBannerService;
    }

    @Override
    protected CmsBannerService service() {
        return cmsBannerService;
    }

    @Override
    protected String permPrefix() {
        return "cms:banner";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"title", "title_en"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<CmsBanner> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("position")), "position", params.get("position"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByAsc("sort");
    }

    /** 前台按位置获取启用中的 banner */
    @RequiresPerm("")
    @GetMapping("/position/{position}")
    public R<List<CmsBanner>> listByPosition(@PathVariable String position) {
        return R.ok(cmsBannerService.listByPosition(position));
    }
}
