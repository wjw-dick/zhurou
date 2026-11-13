package com.zhushi.order.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 订单明细
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("order_item")
public class OrderItem extends BaseEntity {

    private Long orderId;
    private String orderNo;
    private Long productId;
    private Long skuId;
    private String productName;
    private String skuName;
    private String cover;
    private BigDecimal price;
    private Integer quantity;
    /** 预估重量(kg) */
    private BigDecimal weight;
    /** 实称重量(kg) */
    private BigDecimal actualWeight;
    private BigDecimal amount;
    /** 分割选项 CUBE切块/MINCED绞肉/SLICED切片 */
    private String splitType;
    private BigDecimal splitFee;
}
