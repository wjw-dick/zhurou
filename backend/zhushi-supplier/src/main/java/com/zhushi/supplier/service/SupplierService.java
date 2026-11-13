package com.zhushi.supplier.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.supplier.entity.Supplier;
import com.zhushi.supplier.mapper.SupplierMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 供应商档案服务
 */
@Service
public class SupplierService extends ServiceImpl<SupplierMapper, Supplier> {

    /** 合作中的供应商下拉 */
    public List<Supplier> listEnabled() {
        return list(new LambdaQueryWrapper<Supplier>()
                .eq(Supplier::getStatus, 1)
                .orderByAsc(Supplier::getCode));
    }
}
