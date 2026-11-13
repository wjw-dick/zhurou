package com.zhushi.supplier.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 送货单
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("supplier_delivery")
public class SupplierDelivery extends BaseEntity {

    private String deliveryNo;
    private Long purchaseId;
    private Long supplierId;
    private LocalDateTime deliveryTime;
    private String driver;
    private String driverPhone;
    /** 冷链温度（℃） */
    private BigDecimal coldChainTemp;
    /** DELIVERING 配送中 / RECEIVED 已收货 */
    private String status;
}
