package com.zhushi.supplier.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 供应商对账单 / 结算
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("supplier_settlement")
public class SupplierSettlement extends BaseEntity {

    private String settleNo;
    private Long supplierId;
    private LocalDate periodStart;
    private LocalDate periodEnd;
    /** 应付金额 */
    private BigDecimal amount;
    /** 已付金额 */
    private BigDecimal paidAmount;
    /** PENDING 待对账 / CONFIRMED 已对账 / PAID 已付款 */
    private String status;
    private String remark;
}
