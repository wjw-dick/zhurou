package com.zhushi.supplier.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 供货单 / 采购单
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("purchase_order")
public class PurchaseOrder extends BaseEntity {

    /** 供货单号 */
    private String purchaseNo;
    private Long supplierId;
    private Long storeId;
    private BigDecimal totalAmount;
    /** 已结算金额 */
    private BigDecimal settleAmount;
    /** CREATED 待发货 / DELIVERING 配送中 / RECEIVED 已入库 / CHECKING 对账中 / SETTLED 已结算 */
    private String status;
    /** 期望到货 */
    private LocalDate expectDate;
    private LocalDateTime receiveTime;
    /** 入库单 */
    private Long inventoryId;
    private String remark;

    /** 供货明细（非数据库字段，保存供货单时一并处理） */
    @TableField(exist = false)
    private List<PurchaseItem> items;
}
