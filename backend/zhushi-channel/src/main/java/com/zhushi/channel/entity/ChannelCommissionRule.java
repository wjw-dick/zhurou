package com.zhushi.channel.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 渠道佣金规则（后台可配：全局 / 渠道 / 品类 / 商品）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("channel_commission_rule")
public class ChannelCommissionRule extends BaseEntity {

    private String name;
    /** 为空表示全局规则 */
    private Long channelId;
    /** 适用品类，空=全部 */
    private String bizType;
    /** 指定商品 */
    private Long productId;
    /** 层级 1 一级 2 二级 */
    private Integer level;
    /** RATE 按比例 / FIXED 固定金额 */
    private String ruleType;
    /** 佣金比例(%) */
    private BigDecimal rate;
    /** 固定佣金 */
    private BigDecimal fixedAmount;
    private Integer status;
}
