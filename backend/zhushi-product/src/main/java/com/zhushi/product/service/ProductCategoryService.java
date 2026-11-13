package com.zhushi.product.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.product.entity.ProductCategory;
import com.zhushi.product.mapper.ProductCategoryMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductCategoryService extends ServiceImpl<ProductCategoryMapper, ProductCategory> {

    public List<ProductCategory> listEnabled() {
        return list(new LambdaQueryWrapper<ProductCategory>()
                .eq(ProductCategory::getStatus, 1)
                .orderByAsc(ProductCategory::getSort));
    }

    public List<ProductCategory> listByBizType(String bizType) {
        return list(new LambdaQueryWrapper<ProductCategory>()
                .eq(bizType != null && !bizType.isBlank(), ProductCategory::getBizType, bizType)
                .eq(ProductCategory::getStatus, 1)
                .orderByAsc(ProductCategory::getSort));
    }
}
