package com.zhushi.staff.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 店员/分割师傅
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("staff")
public class Staff extends BaseEntity {

    private Long userId;
    private Long storeId;
    private String name;
    private String phone;
    private String staffType;
    private BigDecimal commissionRate;
    private Integer status;
}
