package com.zhushi.product.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.util.List;

/**
 * 商品
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("product")
public class Product extends BaseEntity {

    private Long categoryId;
    private String name;
    private String subTitle;
    /** PORK / HOTPOT / PROCESSED / BASE / SET */
    private String bizType;
    private String cover;
    private String images;
    /** 富文本详情（WangEditor 5） */
    private String detail;
    private String unit;
    private String origin;
    private String shelfLife;
    private String storageCond;
    private String cookTip;
    private Integer reservable;
    private Integer splitEnabled;
    private BigDecimal splitFee;
    private BigDecimal commissionRate;
    /** WEIGHT / FIXED */
    private String settleType;
    private String tags;
    private Integer sales;
    private Integer sort;
    /** 0 待审核 / 1 上架 / 2 下架 */
    private Integer status;
    private String auditRemark;

    /** 分类名称（非数据库字段） */
    @TableField(exist = false)
    private String categoryName;

    /** 规格列表 / 检疫资质（非数据库字段，保存商品时一并处理） */
    @TableField(exist = false)
    private List<ProductSku> skus;

    @TableField(exist = false)
    private List<ProductQualification> qualifications;

    @TableField(exist = false)
    private List<ProductStore> stores;
}
