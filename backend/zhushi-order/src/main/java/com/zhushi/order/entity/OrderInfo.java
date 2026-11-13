package com.zhushi.order.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 订单
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("order_info")
public class OrderInfo extends BaseEntity {

    private String orderNo;
    private Long memberId;
    private Long storeId;
    /** NORMAL普通/RESERVE鲜肉预订/SET火锅套餐/GIFT礼盒 */
    private String orderType;
    /** MINIAPP/H5/PC/STAFF/CHANNEL */
    private String source;
    /** UNPAID待支付/PREPARING待备货/READY待取货/DELIVERING配送中/COMPLETED已完成/CANCELLED已取消/AFTERSALE售后 */
    private String status;
    /** SELF_PICKUP自提/DELIVERY配送 */
    private String deliveryType;
    /** 预订/取货日期 */
    private LocalDate appointDate;
    private String appointSlot;
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private BigDecimal totalAmount;
    private BigDecimal splitFee;
    private BigDecimal deliveryFee;
    private BigDecimal discountAmount;
    private BigDecimal payAmount;
    private BigDecimal costAmount;
    /** UNPAID/PAID/REFUNDED/PART_REFUND */
    private String payStatus;
    /** WECHAT/BALANCE/CASH */
    private String payType;
    private LocalDateTime payTime;
    /** 渠道商ID */
    private Long channelId;
    /** 开单店员 */
    private Long staffId;
    private String remark;
    private String cancelReason;
    private LocalDateTime finishTime;
    /** 支付超时时间 */
    private LocalDateTime expireTime;
}
