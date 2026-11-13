package com.zhushi.reserve.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 鲜肉预订配置（分割加工费 / 损耗率可配）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("reserve_config")
public class ReserveConfig extends BaseEntity {

    private Long storeId;
    /** 可预订天数(当天/次日) */
    private Integer reserveDays;
    /** 当日预订截止时间 */
    private String cutoffTime;
    /** 切块加工费 */
    private BigDecimal splitFeeCube;
    /** 绞肉加工费 */
    private BigDecimal splitFeeMinced;
    /** 切片加工费 */
    private BigDecimal splitFeeSliced;
    /** 分割损耗率(%) */
    private BigDecimal lossRate;
    private Integer status;
}
