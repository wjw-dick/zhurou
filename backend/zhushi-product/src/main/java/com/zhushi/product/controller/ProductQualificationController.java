package com.zhushi.product.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.product.entity.ProductQualification;
import com.zhushi.product.service.ProductQualificationService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 商品检疫资质（猪肉两证两章 / SC）
 */
@Tag(name = "商品检疫资质")
@RestController
@RequestMapping("/product/qualification")
public class ProductQualificationController extends BaseController<ProductQualificationService, ProductQualification> {

    private final ProductQualificationService qualificationService;

    public ProductQualificationController(ProductQualificationService qualificationService,
                                          PermChecker permChecker) {
        super(permChecker);
        this.qualificationService = qualificationService;
    }

    @Override
    protected ProductQualificationService service() {
        return qualificationService;
    }

    @Override
    protected String permPrefix() {
        return "product:qualification";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"qual_no", "issuer"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<ProductQualification> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("productId")), "product_id", params.get("productId"))
                .eq(StrUtil.isNotBlank(params.get("qualType")), "qual_type", params.get("qualType"))
                .orderByDesc("id");
    }
}
