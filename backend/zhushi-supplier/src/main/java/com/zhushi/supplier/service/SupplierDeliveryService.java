package com.zhushi.supplier.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.util.BizNoUtil;
import com.zhushi.supplier.entity.SupplierDelivery;
import com.zhushi.supplier.mapper.SupplierDeliveryMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 送货单服务
 */
@Service
public class SupplierDeliveryService extends ServiceImpl<SupplierDeliveryMapper, SupplierDelivery> {

    /** 某供货单的送货记录 */
    public List<SupplierDelivery> listByPurchase(Long purchaseId) {
        return list(new LambdaQueryWrapper<SupplierDelivery>()
                .eq(SupplierDelivery::getPurchaseId, purchaseId)
                .orderByDesc(SupplierDelivery::getId));
    }

    /** 保存送货单并自动生成送货单号 */
    public void saveWithNo(SupplierDelivery delivery) {
        if (delivery.getDeliveryNo() == null || delivery.getDeliveryNo().isBlank()) {
            delivery.setDeliveryNo(BizNoUtil.next("DL"));
        }
        save(delivery);
    }

    /** 查询数量（预留统计入口） */
    public long countByStatus(String status) {
        return count(new QueryWrapper<SupplierDelivery>().eq("status", status));
    }
}
