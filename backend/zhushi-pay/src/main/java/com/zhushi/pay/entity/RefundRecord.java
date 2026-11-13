package com.zhushi.pay.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 退款记录
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("refund_record")
public class RefundRecord extends BaseEntity {

    private String refundNo;
    private Long orderId;
    private String orderNo;
    private Long aftersaleId;
    private BigDecimal amount;
    private String refundType;
    private String status;
    private LocalDateTime refundTime;
    private String remark;
}
