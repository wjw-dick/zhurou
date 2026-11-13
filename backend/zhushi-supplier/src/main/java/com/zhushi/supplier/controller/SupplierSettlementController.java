package com.zhushi.supplier.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.common.util.BizNoUtil;
import com.zhushi.supplier.entity.SupplierSettlement;
import com.zhushi.supplier.service.SupplierSettlementService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.Map;

/**
 * 供应商对账 / 结算
 */
@Tag(name = "供应商结算")
@RestController
@RequestMapping("/supplier/settlement")
public class SupplierSettlementController extends BaseController<SupplierSettlementService, SupplierSettlement> {

    private final SupplierSettlementService settlementService;

    public SupplierSettlementController(SupplierSettlementService settlementService, PermChecker permChecker) {
        super(permChecker);
        this.settlementService = settlementService;
    }

    @Override
    protected SupplierSettlementService service() {
        return settlementService;
    }

    @Override
    protected String permPrefix() {
        return "supplier:settlement";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"settle_no", "remark"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SupplierSettlement> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("supplierId")), "supplier_id", params.get("supplierId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    @Override
    protected void beforeSave(SupplierSettlement settlement) {
        if (settlement.getSettleNo() == null || settlement.getSettleNo().isBlank()) {
            settlement.setSettleNo(BizNoUtil.next("SS"));
        }
        if (settlement.getStatus() == null || settlement.getStatus().isBlank()) {
            settlement.setStatus("PENDING");
        }
    }

    /** 确认对账 */
    @OperationLog(module = "供应商结算", action = "确认对账")
    @RequiresPerm("supplier:settlement:confirm")
    @PutMapping("/{id}/confirm")
    public R<Void> confirm(@PathVariable Long id) {
        settlementService.confirm(id);
        return R.ok("对账确认完成", null);
    }

    /** 付款 */
    @OperationLog(module = "供应商结算", action = "供应商付款")
    @RequiresPerm("supplier:settlement:pay")
    @PutMapping("/{id}/pay")
    public R<Void> pay(@PathVariable Long id, @RequestParam(required = false) BigDecimal paidAmount) {
        settlementService.pay(id, paidAmount);
        return R.ok("付款完成", null);
    }
}
