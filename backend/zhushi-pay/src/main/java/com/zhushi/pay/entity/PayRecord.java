package com.zhushi.pay.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 支付记录
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("pay_record")
public class PayRecord extends BaseEntity {

    private String payNo;
    private Long orderId;
    private String orderNo;
    private Long memberId;
    private String payType;
    private BigDecimal amount;
    private String outTradeNo;
    private String transactionId;
    private String status;
    private LocalDateTime payTime;
    private String rawData;
}
