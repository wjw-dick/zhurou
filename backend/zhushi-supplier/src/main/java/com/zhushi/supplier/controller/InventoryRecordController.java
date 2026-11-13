package com.zhushi.supplier.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.supplier.entity.InventoryRecord;
import com.zhushi.supplier.service.InventoryRecordService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 出入库 / 损耗记录
 */
@Tag(name = "出入库记录")
@RestController
@RequestMapping("/supplier/inventory")
public class InventoryRecordController extends BaseController<InventoryRecordService, InventoryRecord> {

    private final InventoryRecordService recordService;

    public InventoryRecordController(InventoryRecordService recordService, PermChecker permChecker) {
        super(permChecker);
        this.recordService = recordService;
    }

    @Override
    protected InventoryRecordService service() {
        return recordService;
    }

    @Override
    protected String permPrefix() {
        return "inventory:record";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"biz_no", "remark"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<InventoryRecord> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("productId")), "product_id", params.get("productId"))
                .eq(StrUtil.isNotBlank(params.get("recordType")), "record_type", params.get("recordType"))
                .orderByDesc("id");
    }

    @Override
    protected void beforeSave(InventoryRecord record) {
        if (record.getRecordType() == null || record.getRecordType().isBlank()) {
            record.setRecordType("IN");
        }
    }
}
