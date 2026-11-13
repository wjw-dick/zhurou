package com.zhushi.store.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 门店（多门店）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("store")
public class Store extends BaseEntity {

    private String code;
    private String name;
    private Long managerId;
    private String contact;
    private String phone;
    private String province;
    private String city;
    private String district;
    private String address;
    private BigDecimal lng;
    private BigDecimal lat;
    private String businessHours;
    private BigDecimal deliveryRadiusKm;
    private BigDecimal deliveryFee;
    private BigDecimal freeDeliveryAmount;
    private BigDecimal minOrderAmount;
    private String images;
    private String intro;
    private Integer status;
    private Integer sort;
}
