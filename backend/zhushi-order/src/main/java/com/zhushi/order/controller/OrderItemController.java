package com.zhushi.order.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.order.entity.OrderItem;
import com.zhushi.order.service.OrderItemService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 订单明细（超管全量维护）
 */
@Tag(name = "订单明细")
@RestController
@RequestMapping("/order/item")
public class OrderItemController extends BaseController<OrderItemService, OrderItem> {

    private final OrderItemService orderItemService;

    public OrderItemController(OrderItemService orderItemService, PermChecker permChecker) {
        super(permChecker);
        this.orderItemService = orderItemService;
    }

    @Override
    protected OrderItemService service() {
        return orderItemService;
    }

    @Override
    protected String permPrefix() {
        return "order:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"product_name"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<OrderItem> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("orderId")), "order_id", params.get("orderId"))
                .eq(StrUtil.isNotBlank(params.get("orderNo")), "order_no", params.get("orderNo"))
                .eq(StrUtil.isNotBlank(params.get("productId")), "product_id", params.get("productId"))
                .orderByAsc("id");
    }
}
