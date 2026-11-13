package com.zhushi.order.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 订单售后
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("order_aftersale")
public class OrderAftersale extends BaseEntity {

    private String aftersaleNo;
    private Long orderId;
    private String orderNo;
    private Long memberId;
    /** REFUND退款/RETURN退货/EXCHANGE换货 */
    private String aftersaleType;
    private String reason;
    private String images;
    private BigDecimal amount;
    /** APPLYING待审核/AGREED已同意/REJECTED已拒绝/DONE已完成 */
    private String status;
    private String auditRemark;
    private LocalDateTime auditTime;
}
