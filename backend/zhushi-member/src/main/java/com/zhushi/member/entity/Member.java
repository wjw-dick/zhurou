package com.zhushi.member.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 会员
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("member")
public class Member extends BaseEntity {

    /** 微信 UnionID */
    private String unionid;
    /** 小程序 openid */
    private String openid;
    /** 公众号 openid */
    private String mpOpenid;
    private String nickname;
    private String avatar;
    private String phone;
    private Integer gender;
    /** 会员等级 */
    private Long levelId;
    /** 储值余额 */
    private BigDecimal balance;
    /** 积分 */
    private Integer points;
    /** 累计消费 */
    private BigDecimal totalAmount;
    /** 常用门店 */
    private Long defaultStoreId;
    /** 1正常 0禁用 */
    private Integer status;
}
