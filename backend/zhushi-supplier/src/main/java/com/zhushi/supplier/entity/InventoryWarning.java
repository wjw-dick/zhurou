package com.zhushi.supplier.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 库存预警
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("inventory_warning")
public class InventoryWarning extends BaseEntity {

    private Long storeId;
    private Long productId;
    private Long skuId;
    private BigDecimal currentStock;
    private BigDecimal warnStock;
    /** PENDING 待处理 / HANDLED 已处理 */
    private String status;
}
