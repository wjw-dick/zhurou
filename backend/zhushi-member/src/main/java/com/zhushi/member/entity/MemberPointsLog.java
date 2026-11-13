package com.zhushi.member.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 积分流水（只读）
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("member_points_log")
public class MemberPointsLog extends BaseEntity {

    private Long memberId;
    /** EARN获得 / USE使用 / REFUND退回 / ADJUST调整 */
    private String changeType;
    /** 变动积分 */
    private Integer points;
    /** 变动后积分 */
    private Integer balance;
    private String bizNo;
    private String remark;
}
