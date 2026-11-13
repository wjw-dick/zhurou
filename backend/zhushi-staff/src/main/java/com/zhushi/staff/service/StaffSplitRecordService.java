package com.zhushi.staff.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.staff.entity.Staff;
import com.zhushi.staff.entity.StaffSplitRecord;
import com.zhushi.staff.mapper.StaffSplitRecordMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

/**
 * 分割加工登记服务：登记并累计当天业绩
 */
@Service
@RequiredArgsConstructor
public class StaffSplitRecordService extends ServiceImpl<StaffSplitRecordMapper, StaffSplitRecord> {

    private final StaffService staffService;
    private final StaffPerformanceService performanceService;

    /** 登记分割加工，并累计当天 staff_performance */
    @Transactional(rollbackFor = Exception.class)
    public StaffSplitRecord register(StaffSplitRecord record) {
        // 禁用手写 id，由数据库自增
        record.setId(null);
        Staff staff = staffService.getById(record.getStaffId());
        if (staff == null) {
            throw new BizException("店员不存在");
        }
        Long storeId = record.getStoreId() != null ? record.getStoreId() : staff.getStoreId();
        record.setStoreId(storeId);
        save(record);
        performanceService.accumulateSplit(record.getStaffId(), storeId, LocalDate.now(),
                record.getWeight(), record.getSplitFee());
        return record;
    }
}
