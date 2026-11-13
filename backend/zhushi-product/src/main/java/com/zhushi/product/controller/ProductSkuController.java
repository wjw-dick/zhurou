package com.zhushi.product.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.product.entity.ProductSku;
import com.zhushi.product.service.ProductSkuService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 商品规格（超管全量维护）
 */
@Tag(name = "商品规格")
@RestController
@RequestMapping("/product/sku")
public class ProductSkuController extends BaseController<ProductSkuService, ProductSku> {

    private final ProductSkuService skuService;

    public ProductSkuController(ProductSkuService skuService, PermChecker permChecker) {
        super(permChecker);
        this.skuService = skuService;
    }

    @Override
    protected ProductSkuService service() {
        return skuService;
    }

    @Override
    protected String permPrefix() {
        return "product:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"sku_name", "spec", "barcode"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<ProductSku> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("productId")), "product_id", params.get("productId"))
                .orderByAsc("id");
    }
}
