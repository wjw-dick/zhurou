package com.zhushi.channel.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 渠道商档案（团购 / 分销 / 加盟）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("channel")
public class Channel extends BaseEntity {

    private String code;
    private String name;
    private Long userId;
    /** 上级渠道商，0=顶级 */
    private Long parentId;
    /** 层级 1 一级 2 二级 */
    private Integer level;
    /** GROUP 团购 / DISTRIBUTOR 分销 / FRANCHISE 加盟 */
    private String channelType;
    private String contact;
    private String phone;
    /** 默认佣金比例(%) */
    private BigDecimal commissionRate;
    /** 授信额度 */
    private BigDecimal creditLimit;
    /** 已用额度 */
    private BigDecimal usedCredit;
    /** 可销售门店（逗号分隔） */
    private String storeIds;
    private Integer status;
    private String remark;
}
