package com.zhushi.supplier.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 出入库 / 损耗记录
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("inventory_record")
public class InventoryRecord extends BaseEntity {

    private Long storeId;
    private Long productId;
    /** IN 入库 / OUT 出库 / LOSS 损耗 / CHECK 盘点 */
    private String recordType;
    private BigDecimal quantity;
    private BigDecimal beforeStock;
    private BigDecimal afterStock;
    /** 关联单号 */
    private String bizNo;
    private String remark;
}
