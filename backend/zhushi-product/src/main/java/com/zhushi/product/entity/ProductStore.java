package com.zhushi.product.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 商品-门店可售与库存
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("product_store")
public class ProductStore extends BaseEntity {

    private Long productId;
    private Long storeId;
    private Integer stock;
    private Integer status;
}
