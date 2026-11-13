package com.zhushi.cms.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.cms.entity.CmsArticle;
import com.zhushi.cms.service.CmsArticleService;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * CMS 文章 / 资讯 / 品牌故事 / 案例 / 单页 管理
 */
@Tag(name = "CMS文章")
@RestController
@RequestMapping("/cms/article")
public class CmsArticleController extends BaseController<CmsArticleService, CmsArticle> {

    private final CmsArticleService cmsArticleService;

    public CmsArticleController(CmsArticleService cmsArticleService, PermChecker permChecker) {
        super(permChecker);
        this.cmsArticleService = cmsArticleService;
    }

    @Override
    protected CmsArticleService service() {
        return cmsArticleService;
    }

    @Override
    protected String permPrefix() {
        return "cms:article";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"title", "title_en", "author", "source"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<CmsArticle> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("categoryId")), "category_id", params.get("categoryId"))
                .eq(StrUtil.isNotBlank(params.get("articleType")), "article_type", params.get("articleType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("is_top")
                .orderByDesc("id");
    }

    /** 发布文章 */
    @OperationLog(module = "CMS文章", action = "发布文章")
    @RequiresPerm("cms:article:edit")
    @GetMapping("/{id}/publish")
    public R<Void> publish(@PathVariable Long id) {
        cmsArticleService.publish(id);
        return R.ok("发布成功", null);
    }
}
