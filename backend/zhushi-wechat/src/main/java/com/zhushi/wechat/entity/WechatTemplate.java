package com.zhushi.wechat.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 公众号模板消息配置
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wechat_template")
public class WechatTemplate extends BaseEntity {

    /** ORDER_PAID / ORDER_PREPARING / ORDER_READY / ORDER_DELIVERING / ACTIVITY */
    private String bizType;
    /** 微信模板 ID */
    private String templateId;
    private String title;
    /** 模板字段映射 */
    private String contentJson;
    private Integer status;
}
