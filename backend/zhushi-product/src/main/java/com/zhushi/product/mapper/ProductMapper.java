package com.zhushi.product.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zhushi.product.entity.Product;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ProductMapper extends BaseMapper<Product> {
}
