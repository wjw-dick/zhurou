package com.zhushi.pay.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.util.BizNoUtil;
import com.zhushi.pay.entity.PayRecord;
import com.zhushi.pay.mapper.PayRecordMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 支付服务：生成支付单 / 模拟支付回调
 */
@Service
public class PayRecordService extends ServiceImpl<PayRecordMapper, PayRecord> {

    /** 生成支付单（预支付） */
    public PayRecord prepay(Long orderId, String orderNo, Long memberId, String payType, BigDecimal amount) {
        PayRecord record = new PayRecord();
        record.setPayNo(BizNoUtil.next("PAY"));
        record.setOrderId(orderId);
        record.setOrderNo(orderNo);
        record.setMemberId(memberId);
        record.setPayType(payType == null ? "WECHAT" : payType);
        record.setAmount(amount == null ? BigDecimal.ZERO : amount);
        record.setStatus("UNPAID");
        save(record);
        return record;
    }

    /** 模拟支付回调：置为已支付并记录交易号 */
    @Transactional(rollbackFor = Exception.class)
    public PayRecord notify(String payNo, String transactionId) {
        PayRecord record = getOne(new LambdaQueryWrapper<PayRecord>().eq(PayRecord::getPayNo, payNo), false);
        if (record == null) {
            throw new BizException("支付单不存在");
        }
        record.setStatus("PAID");
        record.setTransactionId(transactionId);
        record.setPayTime(LocalDateTime.now());
        updateById(record);
        return record;
    }
}
