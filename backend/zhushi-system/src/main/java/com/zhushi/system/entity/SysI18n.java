package com.zhushi.system.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 多语言词条
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_i18n")
public class SysI18n extends BaseEntity {

    private String langCode;
    private String module;
    private String i18nKey;
    private String i18nValue;
}
