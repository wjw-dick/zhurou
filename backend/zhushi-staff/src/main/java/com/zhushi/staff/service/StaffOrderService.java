package com.zhushi.staff.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.util.BizNoUtil;
import com.zhushi.staff.entity.Staff;
import com.zhushi.staff.entity.StaffOrder;
import com.zhushi.staff.mapper.StaffOrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;

/**
 * 称重开单服务：计算金额/提成、生成单号并累计当天业绩
 */
@Service
@RequiredArgsConstructor
public class StaffOrderService extends ServiceImpl<StaffOrderMapper, StaffOrder> {

    private static final BigDecimal HUNDRED = new BigDecimal("100");

    private final StaffService staffService;
    private final StaffPerformanceService performanceService;

    /** 称重开单，并累计当天 staff_performance */
    @Transactional(rollbackFor = Exception.class)
    public StaffOrder create(StaffOrder order) {
        Staff staff = staffService.getById(order.getStaffId());
        if (staff == null) {
            throw new BizException("店员不存在");
        }
        // 金额 = 单价 × 重量
        BigDecimal weight = nvl(order.getWeight());
        BigDecimal price = nvl(order.getPrice());
        BigDecimal amount = price.multiply(weight).setScale(2, RoundingMode.HALF_UP);
        order.setAmount(amount);
        // 提成 = 金额 × 店员提成比例 / 100
        BigDecimal rate = nvl(staff.getCommissionRate());
        BigDecimal commission = amount.multiply(rate).divide(HUNDRED, 2, RoundingMode.HALF_UP);
        order.setCommission(commission);
        // 生成称重开单号
        order.setOrderNo(BizNoUtil.next("SO"));
        order.setId(null);
        Long storeId = order.getStoreId() != null ? order.getStoreId() : staff.getStoreId();
        order.setStoreId(storeId);
        save(order);
        performanceService.accumulateOrder(order.getStaffId(), storeId, LocalDate.now(), amount, commission);
        return order;
    }

    private BigDecimal nvl(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }
}
