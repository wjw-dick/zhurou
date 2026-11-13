package com.zhushi.channel.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 渠道专属价
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("channel_price")
public class ChannelPrice extends BaseEntity {

    private Long channelId;
    private Long productId;
    private Long skuId;
    /** 渠道专属价 */
    private BigDecimal price;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer status;
}
