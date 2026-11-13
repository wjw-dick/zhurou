package com.zhushi.order.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.order.entity.OrderInfo;
import com.zhushi.order.entity.OrderItem;
import com.zhushi.order.service.OrderInfoService;
import com.zhushi.order.service.OrderItemService;
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
 * 订单管理：下单 + 备货 / 发货 / 完成 / 取消 状态流转 + 明细查询
 */
@Tag(name = "订单管理")
@RestController
@RequestMapping("/order/info")
public class OrderInfoController extends BaseController<OrderInfoService, OrderInfo> {

    private final OrderInfoService orderInfoService;
    private final OrderItemService orderItemService;

    public OrderInfoController(OrderInfoService orderInfoService, OrderItemService orderItemService,
                              PermChecker permChecker) {
        super(permChecker);
        this.orderInfoService = orderInfoService;
        this.orderItemService = orderItemService;
    }

    @Override
    protected OrderInfoService service() {
        return orderInfoService;
    }

    @Override
    protected String permPrefix() {
        return "order:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"order_no", "receiver_name", "receiver_phone"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<OrderInfo> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("memberId")), "member_id", params.get("memberId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .eq(StrUtil.isNotBlank(params.get("orderType")), "order_type", params.get("orderType"))
                .eq(StrUtil.isNotBlank(params.get("source")), "source", params.get("source"))
                .eq(StrUtil.isNotBlank(params.get("payStatus")), "pay_status", params.get("payStatus"))
                .ge(StrUtil.isNotBlank(params.get("startTime")), "create_time", params.get("startTime"))
                .le(StrUtil.isNotBlank(params.get("endTime")), "create_time", params.get("endTime"))
                .orderByDesc("id");
    }

    /** 新增订单：自动生成订单号并写状态日志 */
    @OperationLog(module = "订单管理", action = "新增订单")
    @Override
    @PostMapping
    public R<Long> save(@RequestBody OrderInfo order) {
        permChecker.require("order:info:add");
        return R.ok(orderInfoService.createOrder(order));
    }

    /** 查询订单明细 */
    @RequiresPerm("order:info:list")
    @GetMapping("/{id}/items")
    public R<List<OrderItem>> items(@PathVariable Long id) {
        return R.ok(orderItemService.listByOrderId(id));
    }

    /** 备货：状态流转为 PREPARING */
    @OperationLog(module = "订单管理", action = "订单备货")
    @RequiresPerm("order:info:prepare")
    @PutMapping("/{id}/prepare")
    public R<Void> prepare(@PathVariable Long id) {
        orderInfoService.prepare(id);
        return R.ok();
    }

    /** 发货：状态流转为 DELIVERING */
    @OperationLog(module = "订单管理", action = "订单发货")
    @RequiresPerm("order:info:deliver")
    @PutMapping("/{id}/deliver")
    public R<Void> deliver(@PathVariable Long id) {
        orderInfoService.deliver(id);
        return R.ok();
    }

    /** 完成：状态流转为 COMPLETED */
    @OperationLog(module = "订单管理", action = "订单完成")
    @RequiresPerm("order:info:finish")
    @PutMapping("/{id}/finish")
    public R<Void> finish(@PathVariable Long id) {
        orderInfoService.finish(id);
        return R.ok();
    }

    /** 取消：状态流转为 CANCELLED */
    @OperationLog(module = "订单管理", action = "订单取消")
    @RequiresPerm("order:info:cancel")
    @PutMapping("/{id}/cancel")
    public R<Void> cancel(@PathVariable Long id, @RequestParam(required = false) String reason) {
        orderInfoService.cancel(id, reason);
        return R.ok();
    }
}
