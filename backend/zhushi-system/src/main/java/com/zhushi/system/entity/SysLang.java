package com.zhushi.system.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 语言
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_lang")
public class SysLang extends BaseEntity {

    private String code;
    private String name;
    private Integer isDefault;
    private Integer status;
    private Integer sort;
}
