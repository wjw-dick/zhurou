package com.zhushi.cms.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 留言 / 团购咨询
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("cms_message")
public class CmsMessage extends BaseEntity {

    /** CONTACT联系我们 / GROUP团购企业团单 */
    private String msgType;
    private String name;
    private String phone;
    private String company;
    private String email;
    private String content;
    private String city;
    /** UNREAD未读 / READ已读 / DONE已处理 */
    private String status;
    private String remark;
}
