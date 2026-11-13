package com.zhushi.supplier.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 供应商档案
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("supplier")
public class Supplier extends BaseEntity {

    private String code;
    private String name;
    /** 供应商端登录账号 */
    private Long userId;
    private String contact;
    private String phone;
    private String address;
    /** PORK 猪肉 / HOTPOT 火锅食材 / PROCESSED 肉制品 / BASE 底料 */
    private String supplyType;
    /** MONTH 月结 / WEEK 周结 / CASH 现结 */
    private String settleType;
    private String bankName;
    private String bankAccount;
    private String bankHolder;
    /** 评级（1-5） */
    private BigDecimal rating;
    /** 1 合作 / 0 停用 */
    private Integer status;
    private String remark;
}
