package com.zhushi.cms.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * CMS 栏目
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("cms_category")
public class CmsCategory extends BaseEntity {

    private String name;
    private String nameEn;
    private String code;
    private Integer sort;
    private Integer status;
}
