package com.zhushi.product.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.product.entity.Product;
import com.zhushi.product.entity.ProductQualification;
import com.zhushi.product.entity.ProductSku;
import com.zhushi.product.service.ProductService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 商品管理（超管全量维护）：商品 + 规格 + 检疫资质 + 审核 + 上下架
 */
@Tag(name = "商品管理")
@RestController
@RequestMapping("/product/info")
public class ProductController extends BaseController<ProductService, Product> {

    private final ProductService productService;

    public ProductController(ProductService productService, PermChecker permChecker) {
        super(permChecker);
        this.productService = productService;
    }

    @Override
    protected ProductService service() {
        return productService;
    }

    @Override
    protected String permPrefix() {
        return "product:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name", "sub_title", "origin"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<Product> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("categoryId")), "category_id", params.get("categoryId"))
                .eq(StrUtil.isNotBlank(params.get("bizType")), "biz_type", params.get("bizType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .eq(StrUtil.isNotBlank(params.get("reservable")), "reservable", params.get("reservable"))
                .orderByDesc("id");
    }

    @OperationLog(module = "商品管理", action = "新增商品")
    @Override
    @PostMapping
    public R<Long> save(@RequestBody Product product) {
        permChecker.require("product:info:add");
        productService.saveWithRelations(product, product.getSkus(), product.getQualifications());
        return R.ok(product.getId());
    }

    @OperationLog(module = "商品管理", action = "编辑商品")
    @Override
    @PutMapping
    public R<Void> update(@RequestBody Product product) {
        permChecker.require("product:info:edit");
        productService.saveWithRelations(product, product.getSkus(), product.getQualifications());
        return R.ok();
    }

    @RequiresPerm("product:info:list")
    @GetMapping("/{id}/detail")
    public R<Product> detail(@PathVariable Long id) {
        Product product = productService.getById(id);
        if (product != null) {
            product.setSkus(productService.skus(id));
            product.setQualifications(productService.qualifications(id));
        }
        return R.ok(product);
    }

    @RequiresPerm("product:info:list")
    @GetMapping("/{id}/skus")
    public R<List<ProductSku>> skus(@PathVariable Long id) {
        return R.ok(productService.skus(id));
    }

    @RequiresPerm("product:info:list")
    @GetMapping("/{id}/qualifications")
    public R<List<ProductQualification>> qualifications(@PathVariable Long id) {
        return R.ok(productService.qualifications(id));
    }

    /** 审核 */
    @OperationLog(module = "商品管理", action = "商品审核")
    @RequiresPerm("product:info:audit")
    @PutMapping("/{id}/audit")
    public R<Void> audit(@PathVariable Long id,
                         @RequestParam Integer status,
                         @RequestParam(required = false) String remark) {
        productService.audit(id, status, remark);
        return R.ok("审核完成", null);
    }

    /** 上下架 */
    @OperationLog(module = "商品管理", action = "商品上下架")
    @RequiresPerm("product:info:status")
    @PutMapping("/{id}/status")
    public R<Void> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        productService.changeStatus(id, status);
        return R.ok();
    }
}
