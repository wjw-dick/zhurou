package com.zhushi.supplier.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 供货单明细
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("purchase_item")
public class PurchaseItem extends BaseEntity {

    private Long purchaseId;
    private Long productId;
    private String productName;
    private String spec;
    /** 供货单价 */
    private BigDecimal price;
    private BigDecimal quantity;
    private String unit;
    private BigDecimal amount;
}
