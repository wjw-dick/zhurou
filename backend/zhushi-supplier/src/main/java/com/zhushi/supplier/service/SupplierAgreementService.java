package com.zhushi.supplier.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.supplier.entity.SupplierAgreement;
import com.zhushi.supplier.mapper.SupplierAgreementMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 供货协议服务
 */
@Service
public class SupplierAgreementService extends ServiceImpl<SupplierAgreementMapper, SupplierAgreement> {

    /** 某供应商的协议列表 */
    public List<SupplierAgreement> listBySupplier(Long supplierId) {
        return list(new LambdaQueryWrapper<SupplierAgreement>()
                .eq(SupplierAgreement::getSupplierId, supplierId)
                .orderByDesc(SupplierAgreement::getId));
    }
}
