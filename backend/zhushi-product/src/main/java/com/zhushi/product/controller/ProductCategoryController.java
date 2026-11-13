package com.zhushi.product.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.common.util.TreeUtil;
import com.zhushi.product.entity.ProductCategory;
import com.zhushi.product.service.ProductCategoryService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 商品分类（超管全量维护）
 */
@Tag(name = "商品分类")
@RestController
@RequestMapping("/product/category")
public class ProductCategoryController extends BaseController<ProductCategoryService, ProductCategory> {

    private final ProductCategoryService categoryService;

    public ProductCategoryController(ProductCategoryService categoryService, PermChecker permChecker) {
        super(permChecker);
        this.categoryService = categoryService;
    }

    @Override
    protected ProductCategoryService service() {
        return categoryService;
    }

    @Override
    protected String permPrefix() {
        return "product:category";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name", "name_en"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<ProductCategory> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("bizType")), "biz_type", params.get("bizType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByAsc("sort");
    }

    @RequiresPerm("")
    @GetMapping("/tree")
    public R<List<ProductCategory>> tree(@RequestParam(required = false) String bizType) {
        return R.ok(TreeUtil.build(categoryService.listByBizType(bizType)));
    }
}
