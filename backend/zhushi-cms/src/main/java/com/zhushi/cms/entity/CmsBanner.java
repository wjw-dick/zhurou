package com.zhushi.cms.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * Banner
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("cms_banner")
public class CmsBanner extends BaseEntity {

    private String title;
    private String titleEn;
    private String image;
    private String linkUrl;
    /** PC_HOME / MINIAPP_HOME / H5 / SET_BANNER */
    private String position;
    private Integer sort;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer status;
}
