package com.zhushi.staff.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.staff.entity.Staff;
import com.zhushi.staff.mapper.StaffMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StaffService extends ServiceImpl<StaffMapper, Staff> {

    /** 门店下启用店员 */
    public List<Staff> listByStore(Long storeId) {
        return list(new LambdaQueryWrapper<Staff>()
                .eq(Staff::getStoreId, storeId)
                .eq(Staff::getStatus, 1)
                .orderByAsc(Staff::getId));
    }
}
