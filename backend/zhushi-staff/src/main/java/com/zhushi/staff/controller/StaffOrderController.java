package com.zhushi.staff.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.staff.entity.StaffOrder;
import com.zhushi.staff.service.StaffOrderService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 称重开单
 */
@Tag(name = "称重开单")
@RestController
@RequestMapping("/staff/order")
public class StaffOrderController extends BaseController<StaffOrderService, StaffOrder> {

    private final StaffOrderService staffOrderService;

    public StaffOrderController(StaffOrderService staffOrderService, PermChecker permChecker) {
        super(permChecker);
        this.staffOrderService = staffOrderService;
    }

    @Override
    protected StaffOrderService service() {
        return staffOrderService;
    }

    @Override
    protected String permPrefix() {
        return "staff:order";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"order_no", "product_name"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<StaffOrder> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("staffId")), "staff_id", params.get("staffId"))
                .eq(StrUtil.isNotBlank(params.get("memberId")), "member_id", params.get("memberId"))
                .eq(StrUtil.isNotBlank(params.get("payType")), "pay_type", params.get("payType"))
                .orderByDesc("id");
    }

    /** 称重开单（并累计当天业绩） */
    @OperationLog(module = "称重开单", action = "开单")
    @RequiresPerm("staff:order:add")
    @PostMapping("/create")
    public R<StaffOrder> create(@RequestBody StaffOrder order) {
        return R.ok(staffOrderService.create(order));
    }
}
