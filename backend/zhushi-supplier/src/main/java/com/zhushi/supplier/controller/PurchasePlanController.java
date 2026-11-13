package com.zhushi.supplier.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.common.util.BizNoUtil;
import com.zhushi.supplier.entity.PurchasePlan;
import com.zhushi.supplier.service.PurchasePlanService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 采购计划管理
 */
@Tag(name = "采购计划")
@RestController
@RequestMapping("/supplier/plan")
public class PurchasePlanController extends BaseController<PurchasePlanService, PurchasePlan> {

    private final PurchasePlanService planService;

    public PurchasePlanController(PurchasePlanService planService, PermChecker permChecker) {
        super(permChecker);
        this.planService = planService;
    }

    @Override
    protected PurchasePlanService service() {
        return planService;
    }

    @Override
    protected String permPrefix() {
        return "purchase:plan";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"plan_no", "remark"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<PurchasePlan> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    @Override
    protected void beforeSave(PurchasePlan plan) {
        if (plan.getPlanNo() == null || plan.getPlanNo().isBlank()) {
            plan.setPlanNo(BizNoUtil.next("PP"));
        }
        if (plan.getStatus() == null || plan.getStatus().isBlank()) {
            plan.setStatus("DRAFT");
        }
    }
}
