package com.zhushi.wechat.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 模板消息发送日志（只读）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wechat_msg_log")
public class WechatMsgLog extends BaseEntity {

    private String openid;
    private String unionid;
    private String bizType;
    private String templateId;
    private String content;
    private Integer status;
    private String errorMsg;
}
