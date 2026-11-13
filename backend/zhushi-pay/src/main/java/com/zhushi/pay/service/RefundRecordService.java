package com.zhushi.pay.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.util.BizNoUtil;
import com.zhushi.pay.entity.RefundRecord;
import com.zhushi.pay.mapper.RefundRecordMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

/**
 * 退款服务：生成退款单
 */
@Service
public class RefundRecordService extends ServiceImpl<RefundRecordMapper, RefundRecord> {

    /** 申请退款（生成退款单，待处理） */
    public RefundRecord apply(Long orderId, BigDecimal amount, String refundType) {
        RefundRecord record = new RefundRecord();
        record.setRefundNo(BizNoUtil.next("REF"));
        record.setOrderId(orderId);
        record.setAmount(amount == null ? BigDecimal.ZERO : amount);
        record.setRefundType(refundType == null ? "WECHAT" : refundType);
        record.setStatus("APPLYING");
        save(record);
        return record;
    }
}
