package com.zhushi.supplier.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.supplier.entity.PurchaseItem;
import com.zhushi.supplier.entity.PurchaseOrder;
import com.zhushi.supplier.service.PurchaseOrderService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 供货单 / 采购单管理（含收货入库）
 */
@Tag(name = "供货单管理")
@RestController
@RequestMapping("/supplier/purchase")
public class PurchaseOrderController extends BaseController<PurchaseOrderService, PurchaseOrder> {

    private final PurchaseOrderService purchaseService;

    public PurchaseOrderController(PurchaseOrderService purchaseService, PermChecker permChecker) {
        super(permChecker);
        this.purchaseService = purchaseService;
    }

    @Override
    protected PurchaseOrderService service() {
        return purchaseService;
    }

    @Override
    protected String permPrefix() {
        return "purchase:order";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"purchase_no", "remark"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<PurchaseOrder> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("supplierId")), "supplier_id", params.get("supplierId"))
                .eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    /** 新增供货单（含明细） */
    @OperationLog(module = "供货单管理", action = "新增供货单")
    @Override
    @PostMapping
    public R<Long> save(@RequestBody PurchaseOrder order) {
        permChecker.require("purchase:order:add");
        purchaseService.saveWithItems(order, order.getItems());
        return R.ok(order.getId());
    }

    /** 编辑供货单（含明细） */
    @OperationLog(module = "供货单管理", action = "编辑供货单")
    @Override
    @PutMapping
    public R<Void> update(@RequestBody PurchaseOrder order) {
        permChecker.require("purchase:order:edit");
        purchaseService.saveWithItems(order, order.getItems());
        return R.ok();
    }

    /** 供货明细 */
    @RequiresPerm("purchase:order:list")
    @GetMapping("/{id}/items")
    public R<List<PurchaseItem>> items(@PathVariable Long id) {
        return R.ok(purchaseService.items(id));
    }

    /** 收货入库：状态置 RECEIVED 并按明细生成入库记录 */
    @OperationLog(module = "供货单管理", action = "收货入库")
    @RequiresPerm("purchase:order:receive")
    @PutMapping("/{id}/receive")
    public R<Void> receive(@PathVariable Long id, @RequestParam(required = false) Long storeId) {
        purchaseService.receive(id, storeId);
        return R.ok("入库完成", null);
    }
}
