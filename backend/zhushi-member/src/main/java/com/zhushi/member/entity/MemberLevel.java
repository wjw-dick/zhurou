package com.zhushi.member.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 会员等级
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("member_level")
public class MemberLevel extends BaseEntity {

    /** 等级名称 */
    private String name;
    private Integer level;
    /** 升级所需累计消费 */
    private BigDecimal upgradeAmount;
    /** 折扣(百分数 95=95折) */
    private BigDecimal discount;
    /** 积分倍率 */
    private BigDecimal pointsRatio;
    private String icon;
    private Integer status;
}
