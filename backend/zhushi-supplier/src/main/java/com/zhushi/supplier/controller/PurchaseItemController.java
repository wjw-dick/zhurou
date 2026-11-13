package com.zhushi.supplier.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.supplier.entity.PurchaseItem;
import com.zhushi.supplier.service.PurchaseItemService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 供货单明细
 */
@Tag(name = "供货单明细")
@RestController
@RequestMapping("/supplier/purchase/item")
public class PurchaseItemController extends BaseController<PurchaseItemService, PurchaseItem> {

    private final PurchaseItemService itemService;

    public PurchaseItemController(PurchaseItemService itemService, PermChecker permChecker) {
        super(permChecker);
        this.itemService = itemService;
    }

    @Override
    protected PurchaseItemService service() {
        return itemService;
    }

    @Override
    protected String permPrefix() {
        return "purchase:order";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"product_name", "spec"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<PurchaseItem> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("purchaseId")), "purchase_id", params.get("purchaseId"))
                .eq(StrUtil.isNotBlank(params.get("productId")), "product_id", params.get("productId"))
                .orderByAsc("id");
    }
}
