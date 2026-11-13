package com.zhushi.supplier.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.common.util.BizNoUtil;
import com.zhushi.supplier.entity.SupplierDelivery;
import com.zhushi.supplier.service.SupplierDeliveryService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 送货单管理
 */
@Tag(name = "送货单管理")
@RestController
@RequestMapping("/supplier/delivery")
public class SupplierDeliveryController extends BaseController<SupplierDeliveryService, SupplierDelivery> {

    private final SupplierDeliveryService deliveryService;

    public SupplierDeliveryController(SupplierDeliveryService deliveryService, PermChecker permChecker) {
        super(permChecker);
        this.deliveryService = deliveryService;
    }

    @Override
    protected SupplierDeliveryService service() {
        return deliveryService;
    }

    @Override
    protected String permPrefix() {
        return "supplier:delivery";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"delivery_no", "driver", "driver_phone"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SupplierDelivery> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("purchaseId")), "purchase_id", params.get("purchaseId"))
                .eq(StrUtil.isNotBlank(params.get("supplierId")), "supplier_id", params.get("supplierId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    @Override
    protected void beforeSave(SupplierDelivery delivery) {
        if (delivery.getDeliveryNo() == null || delivery.getDeliveryNo().isBlank()) {
            delivery.setDeliveryNo(BizNoUtil.next("DL"));
        }
        if (delivery.getStatus() == null || delivery.getStatus().isBlank()) {
            delivery.setStatus("DELIVERING");
        }
    }
}
