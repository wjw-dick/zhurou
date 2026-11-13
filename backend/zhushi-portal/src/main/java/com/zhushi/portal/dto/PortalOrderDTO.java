package com.zhushi.portal.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * C 端下单入参（小程序 / H5 / 官网共用）
 */
@Data
public class PortalOrderDTO {

    private Long memberId;
    private Long storeId;
    /** NORMAL / RESERVE / SET / GIFT */
    private String orderType = "NORMAL";
    /** MINIAPP / H5 / PC */
    private String source = "MINIAPP";
    /** SELF_PICKUP / DELIVERY */
    private String deliveryType = "SELF_PICKUP";
    private LocalDate appointDate;
    private String appointSlot;
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private String remark;
    /** 预留：渠道商报单 */
    private Long channelId;

    private List<Item> items = new ArrayList<>();

    @Data
    public static class Item {
        private Long productId;
        private Long skuId;
        private String productName;
        private String skuName;
        private String cover;
        private BigDecimal price;
        private Integer quantity = 1;
        private BigDecimal weight;
        /** CUBE / MINCED / SLICED / NONE */
        private String splitType;
        private BigDecimal splitFee;
    }
}
