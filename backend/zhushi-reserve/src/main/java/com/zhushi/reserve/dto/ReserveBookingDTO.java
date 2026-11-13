package com.zhushi.reserve.dto;

import lombok.Data;

import java.time.LocalDate;

/**
 * 预订扣减请求参数
 */
@Data
public class ReserveBookingDTO {

    /** 门店ID */
    private Long storeId;
    /** 商品ID */
    private Long productId;
    /** 规格ID，可为空 */
    private Long skuId;
    /** 预订日期 */
    private LocalDate reserveDate;
    /** 预订数量 */
    private Integer quantity;
}
