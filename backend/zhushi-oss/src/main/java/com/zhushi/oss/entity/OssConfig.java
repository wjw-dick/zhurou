package com.zhushi.oss.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 对象存储配置（5 驱动可切，config_json 加密存储）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oss_config")
public class OssConfig extends BaseEntity {

    /** LOCAL / S3 / OSS / COS / MINIO */
    private String driver;
    private String configJson;
    private Integer isDefault;
    private Integer status;
    private String testResult;
}
