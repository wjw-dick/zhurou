package com.zhushi.supplier.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 采购计划
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("purchase_plan")
public class PurchasePlan extends BaseEntity {

    private String planNo;
    private Long storeId;
    private LocalDate planDate;
    /** DRAFT 草稿 / SUBMITTED 已提交 / DONE 已采购 */
    private String status;
    private BigDecimal totalAmount;
    private String remark;
}
