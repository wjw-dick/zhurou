package com.zhushi.reserve.dto;

import lombok.Data;

import java.time.LocalDate;

/**
 * 备货量汇总项：备货量 / 已预订 / 剩余
 */
@Data
public class ReserveStockSummary {

    private Long id;
    private Long storeId;
    private Long productId;
    private Long skuId;
    private LocalDate reserveDate;
    /** 备货量 */
    private Integer capacity;
    /** 已预订量 */
    private Integer booked;
    /** 剩余可预订量 */
    private Integer remaining;
}
