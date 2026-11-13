package com.zhushi.member.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 优惠券
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("coupon")
public class Coupon extends BaseEntity {

    private String name;
    /** CASH满减 / DISCOUNT折扣 / FREE_DELIVERY免配送费 */
    private String couponType;
    /** 面额 */
    private BigDecimal amount;
    /** 折扣 */
    private BigDecimal discount;
    /** 使用门槛 */
    private BigDecimal minAmount;
    /** 发放总量 */
    private Integer totalCount;
    /** 已领取 */
    private Integer receivedCount;
    /** 每人限领 */
    private Integer perLimit;
    /** 适用门店(逗号),空=全部 */
    private String scopeStore;
    /** 适用品类 */
    private String scopeBizType;
    /** FIXED固定日期 / DAYS领取后N天 */
    private String validType;
    private Integer validDays;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    /** 1上架 0下架 */
    private Integer status;
}
