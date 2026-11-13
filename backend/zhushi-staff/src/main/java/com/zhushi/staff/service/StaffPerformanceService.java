package com.zhushi.staff.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.staff.entity.StaffPerformance;
import com.zhushi.staff.mapper.StaffPerformanceMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Map;

/**
 * 店员业绩服务：按 staff_id + stat_date 累计，并提供区间汇总
 */
@Service
public class StaffPerformanceService extends ServiceImpl<StaffPerformanceMapper, StaffPerformance> {

    private static final BigDecimal ZERO_AMOUNT = BigDecimal.ZERO;

    /** 称重开单业绩累计：order_count+1、sales_amount、commission */
    @Transactional(rollbackFor = Exception.class)
    public void accumulateOrder(Long staffId, Long storeId, LocalDate statDate,
                                BigDecimal salesAmount, BigDecimal commission) {
        StaffPerformance perf = getDaily(staffId, statDate);
        if (perf == null) {
            perf = newPerformance(staffId, storeId, statDate);
            perf.setOrderCount(1);
            perf.setSalesAmount(nvl(salesAmount));
            perf.setCommission(nvl(commission));
            save(perf);
        } else {
            perf.setOrderCount(nvlInt(perf.getOrderCount()) + 1);
            perf.setSalesAmount(nvl(perf.getSalesAmount()).add(nvl(salesAmount)));
            perf.setCommission(nvl(perf.getCommission()).add(nvl(commission)));
            updateById(perf);
        }
    }

    /** 分割加工业绩累计：split_count+1、split_weight、commission(加工费) */
    @Transactional(rollbackFor = Exception.class)
    public void accumulateSplit(Long staffId, Long storeId, LocalDate statDate,
                                BigDecimal weight, BigDecimal splitFee) {
        StaffPerformance perf = getDaily(staffId, statDate);
        if (perf == null) {
            perf = newPerformance(staffId, storeId, statDate);
            perf.setSplitCount(1);
            perf.setSplitWeight(nvl(weight));
            perf.setCommission(nvl(splitFee));
            save(perf);
        } else {
            perf.setSplitCount(nvlInt(perf.getSplitCount()) + 1);
            perf.setSplitWeight(nvl(perf.getSplitWeight()).add(nvl(weight)));
            perf.setCommission(nvl(perf.getCommission()).add(nvl(splitFee)));
            updateById(perf);
        }
    }

    /** 区间汇总：order_count / sales_amount / split_count / split_weight / commission */
    public Map<String, Object> summary(Long staffId, LocalDate startDate, LocalDate endDate) {
        QueryWrapper<StaffPerformance> wrapper = new QueryWrapper<>();
        wrapper.select("COALESCE(SUM(order_count),0) AS order_count",
                        "COALESCE(SUM(sales_amount),0) AS sales_amount",
                        "COALESCE(SUM(split_count),0) AS split_count",
                        "COALESCE(SUM(split_weight),0) AS split_weight",
                        "COALESCE(SUM(commission),0) AS commission")
                .eq(staffId != null, "staff_id", staffId)
                .ge(startDate != null, "stat_date", startDate)
                .le(endDate != null, "stat_date", endDate);
        return getMap(wrapper);
    }

    private StaffPerformance getDaily(Long staffId, LocalDate statDate) {
        return getOne(new LambdaQueryWrapper<StaffPerformance>()
                .eq(StaffPerformance::getStaffId, staffId)
                .eq(StaffPerformance::getStatDate, statDate), false);
    }

    private StaffPerformance newPerformance(Long staffId, Long storeId, LocalDate statDate) {
        StaffPerformance perf = new StaffPerformance();
        perf.setStaffId(staffId);
        perf.setStoreId(storeId);
        perf.setStatDate(statDate);
        perf.setOrderCount(0);
        perf.setSalesAmount(ZERO_AMOUNT);
        perf.setSplitCount(0);
        perf.setSplitWeight(BigDecimal.ZERO);
        perf.setCommission(ZERO_AMOUNT);
        return perf;
    }

    private BigDecimal nvl(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }

    private int nvlInt(Integer value) {
        return value == null ? 0 : value;
    }
}
