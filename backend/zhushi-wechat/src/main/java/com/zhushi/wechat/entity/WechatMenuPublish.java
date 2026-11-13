package com.zhushi.wechat.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 公众号菜单发布记录
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wechat_menu_publish")
public class WechatMenuPublish extends BaseEntity {

    /** 发布快照（公众号菜单 JSON） */
    private String menuJson;
    private String publishUser;
    /** SUCCESS / FAILED */
    private String status;
    private String message;
}
