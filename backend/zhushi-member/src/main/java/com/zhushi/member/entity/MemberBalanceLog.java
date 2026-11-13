package com.zhushi.member.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.math.BigDecimal;

/**
 * 储值流水（只读）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("member_balance_log")
public class MemberBalanceLog extends BaseEntity {

    private Long memberId;
    /** RECHARGE充值 / CONSUME消费 / REFUND退款 / ADJUST调整 */
    private String changeType;
    /** 变动金额(正增负减) */
    private BigDecimal amount;
    /** 变动后余额 */
    private BigDecimal balance;
    /** 关联单号 */
    private String bizNo;
    private String remark;
}
