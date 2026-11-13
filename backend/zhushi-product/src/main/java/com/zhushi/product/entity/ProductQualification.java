package com.zhushi.product.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

/**
 * 商品检疫 / 资质证明（猪肉两证两章、SC 等）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("product_qualification")
public class ProductQualification extends BaseEntity {

    private Long productId;
    /** QUARANTINE / QUALITY / SC / INSPECTION */
    private String qualType;
    private String qualNo;
    private String issuer;
    private LocalDate issueDate;
    private LocalDate expireDate;
    private String fileUrl;
    private Integer status;
}
