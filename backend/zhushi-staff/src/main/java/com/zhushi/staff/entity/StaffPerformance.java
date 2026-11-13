package com.zhushi.staff.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 店员业绩/提成（按 staff_id + stat_date 唯一）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("staff_performance")
public class StaffPerformance extends BaseEntity {

    private Long staffId;
    private Long storeId;
    private LocalDate statDate;
    private Integer orderCount;
    private BigDecimal salesAmount;
    private Integer splitCount;
    private BigDecimal splitWeight;
    private BigDecimal commission;
}
