package com.zhushi.channel.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 渠道报单
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("channel_order")
public class ChannelOrder extends BaseEntity {

    private String reportNo;
    private Long channelId;
    private Long orderId;
    private String orderNo;
    private Long storeId;
    private BigDecimal amount;
    /** 佣金 */
    private BigDecimal commission;
    private Long commissionRuleId;
    /** SUBMITTED 待审核 / APPROVED 已通过 / REJECTED 已驳回 / SETTLED 已结算 */
    private String status;
    private String auditRemark;
}
