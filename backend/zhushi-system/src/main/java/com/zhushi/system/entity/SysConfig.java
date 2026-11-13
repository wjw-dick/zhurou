package com.zhushi.system.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 系统参数（可视化配置）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_config")
public class SysConfig extends BaseEntity {

    private String groupCode;
    private String groupName;
    private String configKey;
    private String configName;
    private String configValue;
    /** STRING / NUMBER / BOOLEAN / JSON / IMAGE / TEXT */
    private String valueType;
    /** 是否加密存储 */
    private Integer encrypted;
    private Integer sort;
    private String remark;
}
