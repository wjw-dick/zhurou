package com.zhushi.staff.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 称重开单
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("staff_order")
public class StaffOrder extends BaseEntity {

    private String orderNo;
    private Long storeId;
    private Long staffId;
    private Long memberId;
    private Long productId;
    private String productName;
    private BigDecimal weight;
    private BigDecimal price;
    private BigDecimal amount;
    private String payType;
    private BigDecimal commission;
}
