package com.zhushi.supplier.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.supplier.entity.InventoryWarning;
import com.zhushi.supplier.service.InventoryWarningService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 库存预警（含处理）
 */
@Tag(name = "库存预警")
@RestController
@RequestMapping("/supplier/warning")
public class InventoryWarningController extends BaseController<InventoryWarningService, InventoryWarning> {

    private final InventoryWarningService warningService;

    public InventoryWarningController(InventoryWarningService warningService, PermChecker permChecker) {
        super(permChecker);
        this.warningService = warningService;
    }

    @Override
    protected InventoryWarningService service() {
        return warningService;
    }

    @Override
    protected String permPrefix() {
        return "inventory:warning";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"product_id", "status"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<InventoryWarning> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("productId")), "product_id", params.get("productId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    /** 处理预警 */
    @OperationLog(module = "库存预警", action = "处理预警")
    @RequiresPerm("inventory:warning:handle")
    @PutMapping("/{id}/handle")
    public R<Void> handle(@PathVariable Long id) {
        warningService.handle(id);
        return R.ok("处理完成", null);
    }
}
