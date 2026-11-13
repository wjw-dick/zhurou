package com.zhushi.order.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 订单状态日志
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("order_log")
public class OrderLog extends BaseEntity {

    private Long orderId;
    private String orderNo;
    private String fromStatus;
    private String toStatus;
    private String operator;
    private String remark;
}
