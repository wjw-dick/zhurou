package com.zhushi.channel.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.channel.entity.ChannelSettlement;
import com.zhushi.channel.mapper.ChannelSettlementMapper;
import com.zhushi.common.exception.BizException;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

/**
 * 渠道结算服务
 */
@Service
public class ChannelSettlementService extends ServiceImpl<ChannelSettlementMapper, ChannelSettlement> {

    /** 确认结算单 */
    public void confirm(Long id) {
        ChannelSettlement settlement = getById(id);
        if (settlement == null) {
            throw new BizException("结算单不存在");
        }
        ChannelSettlement update = new ChannelSettlement();
        update.setId(id);
        update.setStatus("CONFIRMED");
        updateById(update);
    }

    /** 打款 */
    public void pay(Long id, BigDecimal paidAmount) {
        ChannelSettlement settlement = getById(id);
        if (settlement == null) {
            throw new BizException("结算单不存在");
        }
        ChannelSettlement update = new ChannelSettlement();
        update.setId(id);
        update.setStatus("PAID");
        update.setPaidAmount(paidAmount == null ? settlement.getAmount() : paidAmount);
        updateById(update);
    }
}
