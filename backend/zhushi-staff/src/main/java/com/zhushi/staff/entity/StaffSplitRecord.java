package com.zhushi.staff.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 分割加工登记
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("staff_split_record")
public class StaffSplitRecord extends BaseEntity {

    private Long storeId;
    private Long staffId;
    private Long orderId;
    private String orderNo;
    private Long orderItemId;
    private String productName;
    private String splitType;
    private BigDecimal weight;
    private BigDecimal lossWeight;
    private BigDecimal splitFee;
}
