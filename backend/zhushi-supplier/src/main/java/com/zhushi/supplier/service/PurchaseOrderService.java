package com.zhushi.supplier.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.util.BizNoUtil;
import com.zhushi.supplier.entity.InventoryRecord;
import com.zhushi.supplier.entity.PurchaseItem;
import com.zhushi.supplier.entity.PurchaseOrder;
import com.zhushi.supplier.mapper.PurchaseOrderMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 供货单服务：明细级联保存 + 收货入库生成出入库记录
 */
@Service
@RequiredArgsConstructor
public class PurchaseOrderService extends ServiceImpl<PurchaseOrderMapper, PurchaseOrder> {

    private final PurchaseItemService purchaseItemService;
    private final InventoryRecordService inventoryRecordService;

    /** 供货单明细 */
    public List<PurchaseItem> items(Long purchaseId) {
        return purchaseItemService.listByPurchase(purchaseId);
    }

    /** 保存供货单及明细（新增/编辑复用） */
    @Transactional(rollbackFor = Exception.class)
    public void saveWithItems(PurchaseOrder order, List<PurchaseItem> items) {
        if (order.getPurchaseNo() == null || order.getPurchaseNo().isBlank()) {
            order.setPurchaseNo(BizNoUtil.next("PO"));
        }
        if (order.getStatus() == null || order.getStatus().isBlank()) {
            order.setStatus("CREATED");
        }
        saveOrUpdate(order);
        if (items != null) {
            purchaseItemService.remove(new LambdaQueryWrapper<PurchaseItem>()
                    .eq(PurchaseItem::getPurchaseId, order.getId()));
            BigDecimal total = BigDecimal.ZERO;
            for (PurchaseItem item : items) {
                item.setId(null);
                item.setPurchaseId(order.getId());
                if (item.getAmount() == null) {
                    item.setAmount(calcAmount(item));
                }
                purchaseItemService.save(item);
                total = total.add(item.getAmount() == null ? BigDecimal.ZERO : item.getAmount());
            }
            PurchaseOrder update = new PurchaseOrder();
            update.setId(order.getId());
            update.setTotalAmount(total);
            updateById(update);
        }
    }

    /**
     * 收货入库：状态置 RECEIVED、写收货时间，并按明细生成入库记录（record_type=IN）
     */
    @Transactional(rollbackFor = Exception.class)
    public void receive(Long id, Long storeId) {
        PurchaseOrder order = getById(id);
        if (order == null) {
            throw new BizException("供货单不存在");
        }
        if ("RECEIVED".equals(order.getStatus())) {
            throw new BizException("该供货单已入库，请勿重复收货");
        }
        Long targetStoreId = storeId != null ? storeId : order.getStoreId();
        PurchaseOrder update = new PurchaseOrder();
        update.setId(id);
        update.setStatus("RECEIVED");
        update.setReceiveTime(LocalDateTime.now());
        updateById(update);

        for (PurchaseItem item : items(id)) {
            InventoryRecord record = new InventoryRecord();
            record.setStoreId(targetStoreId);
            record.setProductId(item.getProductId() == null ? 0L : item.getProductId());
            record.setRecordType("IN");
            record.setQuantity(item.getQuantity());
            record.setBizNo(order.getPurchaseNo());
            record.setRemark("采购入库：" + item.getProductName());
            inventoryRecordService.save(record);
        }
    }

    /** 数量 × 单价 */
    private BigDecimal calcAmount(PurchaseItem item) {
        if (item.getPrice() == null || item.getQuantity() == null) {
            return BigDecimal.ZERO;
        }
        return item.getPrice().multiply(item.getQuantity());
    }
}
