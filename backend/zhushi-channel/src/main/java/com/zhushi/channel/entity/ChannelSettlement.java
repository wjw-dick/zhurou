package com.zhushi.channel.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 渠道商结算单
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("channel_settlement")
public class ChannelSettlement extends BaseEntity {

    private String settleNo;
    private Long channelId;
    private LocalDate periodStart;
    private LocalDate periodEnd;
    /** 应结佣金 */
    private BigDecimal amount;
    private BigDecimal paidAmount;
    /** PENDING 待结算 / CONFIRMED 已确认 / PAID 已打款 */
    private String status;
    private String remark;
}
