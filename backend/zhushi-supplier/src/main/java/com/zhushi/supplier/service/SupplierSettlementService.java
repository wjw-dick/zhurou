package com.zhushi.supplier.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.supplier.entity.SupplierSettlement;
import com.zhushi.supplier.mapper.SupplierSettlementMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

/**
 * 供应商对账 / 结算服务
 */
@Service
public class SupplierSettlementService extends ServiceImpl<SupplierSettlementMapper, SupplierSettlement> {

    /** 确认对账：PENDING → CONFIRMED */
    public void confirm(Long id) {
        SupplierSettlement settlement = getById(id);
        if (settlement == null) {
            throw new BizException("对账单不存在");
        }
        if ("PAID".equals(settlement.getStatus())) {
            throw new BizException("已付款的对账单不可再次确认");
        }
        SupplierSettlement update = new SupplierSettlement();
        update.setId(id);
        update.setStatus("CONFIRMED");
        updateById(update);
    }

    /** 付款：CONFIRMED → PAID，并累加已付金额 */
    @Transactional(rollbackFor = Exception.class)
    public void pay(Long id, BigDecimal paidAmount) {
        SupplierSettlement settlement = getById(id);
        if (settlement == null) {
            throw new BizException("对账单不存在");
        }
        if ("PAID".equals(settlement.getStatus())) {
            throw new BizException("该对账单已付款");
        }
        BigDecimal paid = paidAmount != null ? paidAmount : settlement.getAmount();
        SupplierSettlement update = new SupplierSettlement();
        update.setId(id);
        update.setStatus("PAID");
        update.setPaidAmount(paid == null ? BigDecimal.ZERO : paid);
        updateById(update);
    }
}
