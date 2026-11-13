package com.zhushi.product.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import com.zhushi.common.core.TreeNode;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

/**
 * 商品分类
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("product_category")
public class ProductCategory extends BaseEntity implements TreeNode<ProductCategory> {

    private Long parentId;
    private String name;
    private String nameEn;
    /** PORK / HOTPOT / PROCESSED / BASE / SET */
    private String bizType;
    private String icon;
    private Integer sort;
    private Integer status;

    @TableField(exist = false)
    private List<ProductCategory> children = new ArrayList<>();
}
