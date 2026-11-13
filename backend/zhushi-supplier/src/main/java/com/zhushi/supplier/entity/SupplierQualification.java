package com.zhushi.supplier.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

/**
 * 供应商资质 / 检疫证明（审核）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("supplier_qualification")
public class SupplierQualification extends BaseEntity {

    private Long supplierId;
    /** QUARANTINE 检疫合格证 / SC 食品生产许可 / BUSINESS 营业执照 / INSPECTION 检测报告 */
    private String qualType;
    private String qualNo;
    private String fileUrl;
    private LocalDate issueDate;
    private LocalDate expireDate;
    /** PENDING 待审核 / APPROVED 已通过 / REJECTED 已驳回 */
    private String auditStatus;
    private String auditRemark;
}
