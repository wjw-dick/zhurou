package com.zhushi.supplier.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.supplier.entity.Supplier;
import com.zhushi.supplier.service.SupplierService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 供应商档案管理
 */
@Tag(name = "供应商档案")
@RestController
@RequestMapping("/supplier/info")
public class SupplierController extends BaseController<SupplierService, Supplier> {

    private final SupplierService supplierService;

    public SupplierController(SupplierService supplierService, PermChecker permChecker) {
        super(permChecker);
        this.supplierService = supplierService;
    }

    @Override
    protected SupplierService service() {
        return supplierService;
    }

    @Override
    protected String permPrefix() {
        return "supplier:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name", "code", "contact", "phone"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<Supplier> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .eq(StrUtil.isNotBlank(params.get("supplyType")), "supply_type", params.get("supplyType"))
                .eq(StrUtil.isNotBlank(params.get("settleType")), "settle_type", params.get("settleType"))
                .orderByDesc("id");
    }

    /** 合作中的供应商下拉 */
    @RequiresPerm("")
    @OperationLog(module = "供应商管理", action = "供应商下拉")
    @GetMapping("/options")
    public R<List<Supplier>> options() {
        return R.ok(supplierService.listEnabled());
    }
}
