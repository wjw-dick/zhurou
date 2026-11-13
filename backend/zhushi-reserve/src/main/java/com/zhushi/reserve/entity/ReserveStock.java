package com.zhushi.reserve.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.Version;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

/**
 * 鲜肉预订备货量（Redis 锁防超卖，乐观锁兜底）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("reserve_stock")
public class ReserveStock extends BaseEntity {

    private Long storeId;
    private Long productId;
    private Long skuId;
    /** 预订日期 */
    private LocalDate reserveDate;
    /** 备货量(份/斤) */
    private Integer capacity;
    /** 已预订量 */
    private Integer booked;
    /** 乐观锁版本 */
    @Version
    private Integer version;
}
