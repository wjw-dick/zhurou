package com.zhushi.supplier.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.supplier.entity.PurchaseItem;
import com.zhushi.supplier.mapper.PurchaseItemMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 供货单明细服务
 */
@Service
public class PurchaseItemService extends ServiceImpl<PurchaseItemMapper, PurchaseItem> {

    /** 某供货单的明细列表 */
    public List<PurchaseItem> listByPurchase(Long purchaseId) {
        return list(new LambdaQueryWrapper<PurchaseItem>()
                .eq(PurchaseItem::getPurchaseId, purchaseId)
                .orderByAsc(PurchaseItem::getId));
    }
}
