package com.zhushi.product.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.product.entity.ProductSku;
import com.zhushi.product.mapper.ProductSkuMapper;
import org.springframework.stereotype.Service;

@Service
public class ProductSkuService extends ServiceImpl<ProductSkuMapper, ProductSku> {
}
