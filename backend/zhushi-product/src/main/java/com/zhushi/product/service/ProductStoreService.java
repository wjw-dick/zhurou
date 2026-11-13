package com.zhushi.product.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.product.entity.ProductStore;
import com.zhushi.product.mapper.ProductStoreMapper;
import org.springframework.stereotype.Service;

@Service
public class ProductStoreService extends ServiceImpl<ProductStoreMapper, ProductStore> {
}
