package com.zhushi.order.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.order.entity.OrderAftersale;
import com.zhushi.order.service.OrderAftersaleService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 订单售后（超管全量维护）：新增 / 编辑 / 审核
 */
@Tag(name = "订单售后")
@RestController
@RequestMapping("/order/aftersale")
public class OrderAftersaleController extends BaseController<OrderAftersaleService, OrderAftersale> {

    private final OrderAftersaleService orderAftersaleService;

    public OrderAftersaleController(OrderAftersaleService orderAftersaleService, PermChecker permChecker) {
        super(permChecker);
        this.orderAftersaleService = orderAftersaleService;
    }

    @Override
    protected OrderAftersaleService service() {
        return orderAftersaleService;
    }

    @Override
    protected String permPrefix() {
        return "order:aftersale";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"aftersale_no", "order_no", "reason"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<OrderAftersale> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("orderId")), "order_id", params.get("orderId"))
                .eq(StrUtil.isNotBlank(params.get("orderNo")), "order_no", params.get("orderNo"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .eq(StrUtil.isNotBlank(params.get("aftersaleType")), "aftersale_type", params.get("aftersaleType"))
                .orderByDesc("id");
    }

    /** 售后审核 */
    @OperationLog(module = "订单售后", action = "售后审核")
    @RequiresPerm("order:aftersale:audit")
    @PutMapping("/{id}/audit")
    public R<Void> audit(@PathVariable Long id,
                         @RequestParam String status,
                         @RequestParam(required = false) String remark) {
        orderAftersaleService.audit(id, status, remark);
        return R.ok("审核完成", null);
    }
}
