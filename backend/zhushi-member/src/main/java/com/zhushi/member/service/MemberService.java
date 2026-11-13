package com.zhushi.member.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.member.entity.Member;
import com.zhushi.member.entity.MemberBalanceLog;
import com.zhushi.member.entity.MemberPointsLog;
import com.zhushi.member.mapper.MemberMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * 会员服务：储值 / 积分调整，并同步写入流水
 */
@Service
@RequiredArgsConstructor
public class MemberService extends ServiceImpl<MemberMapper, Member> {

    private final MemberBalanceLogService balanceLogService;
    private final MemberPointsLogService pointsLogService;

    /** 会员储值：更新余额并写入储值流水 */
    @Transactional(rollbackFor = Exception.class)
    public void recharge(Long id, BigDecimal amount, String remark) {
        if (amount == null || amount.signum() <= 0) {
            throw new BizException("储值金额必须大于 0");
        }
        Member member = getById(id);
        if (member == null) {
            throw new BizException("会员不存在");
        }
        BigDecimal before = member.getBalance() == null ? BigDecimal.ZERO : member.getBalance();
        BigDecimal after = before.add(amount);

        Member update = new Member();
        update.setId(id);
        update.setBalance(after);
        updateById(update);

        MemberBalanceLog log = new MemberBalanceLog();
        log.setMemberId(id);
        log.setChangeType("RECHARGE");
        log.setAmount(amount);
        log.setBalance(after);
        log.setRemark(remark);
        balanceLogService.save(log);
    }

    /** 调整积分：更新积分并写入积分流水 */
    @Transactional(rollbackFor = Exception.class)
    public void adjustPoints(Long id, Integer points, String remark) {
        if (points == null || points == 0) {
            throw new BizException("积分变动值不能为 0");
        }
        Member member = getById(id);
        if (member == null) {
            throw new BizException("会员不存在");
        }
        int before = member.getPoints() == null ? 0 : member.getPoints();
        int after = before + points;
        if (after < 0) {
            throw new BizException("积分不足，无法扣减");
        }

        Member update = new Member();
        update.setId(id);
        update.setPoints(after);
        updateById(update);

        MemberPointsLog log = new MemberPointsLog();
        log.setMemberId(id);
        log.setChangeType("ADJUST");
        log.setPoints(points);
        log.setBalance(after);
        log.setRemark(remark);
        pointsLogService.save(log);
    }

    /** 会员储值流水 */
    public List<MemberBalanceLog> balanceLogs(Long memberId) {
        return balanceLogService.list(new LambdaQueryWrapper<MemberBalanceLog>()
                .eq(MemberBalanceLog::getMemberId, memberId)
                .orderByDesc(MemberBalanceLog::getId));
    }

    /** 会员积分流水 */
    public List<MemberPointsLog> pointsLogs(Long memberId) {
        return pointsLogService.list(new LambdaQueryWrapper<MemberPointsLog>()
                .eq(MemberPointsLog::getMemberId, memberId)
                .orderByDesc(MemberPointsLog::getId));
    }
}
