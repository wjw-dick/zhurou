package com.zhushi.oss.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 上传文件记录
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oss_file")
public class OssFile extends BaseEntity {

    private String fileName;
    private String filePath;
    private String url;
    private Long fileSize;
    private String contentType;
    private String driver;
    private String bizType;
}
