package com.zhushi.supplier.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

/**
 * 供货协议
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("supplier_agreement")
public class SupplierAgreement extends BaseEntity {

    private Long supplierId;
    private String agreementNo;
    private String title;
    /** 协议文件 */
    private String fileUrl;
    private LocalDate startDate;
    private LocalDate endDate;
    /** 结算方式 MONTH / WEEK / CASH */
    private String settleType;
    private Integer status;
}
