package com.zhushi.order.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.security.PermChecker;
import com.zhushi.order.entity.OrderLog;
import com.zhushi.order.service.OrderLogService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 订单状态日志：仅可查询，不可增删改（含超管）
 */
@Tag(name = "订单日志")
@RestController
@RequestMapping("/order/log")
public class OrderLogController extends BaseController<OrderLogService, OrderLog> {

    private final OrderLogService orderLogService;

    public OrderLogController(OrderLogService orderLogService, PermChecker permChecker) {
        super(permChecker);
        this.orderLogService = orderLogService;
    }

    @Override
    protected OrderLogService service() {
        return orderLogService;
    }

    @Override
    protected String permPrefix() {
        return "order:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"order_no", "operator", "remark"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<OrderLog> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("orderId")), "order_id", params.get("orderId"))
                .eq(StrUtil.isNotBlank(params.get("orderNo")), "order_no", params.get("orderNo"))
                .eq(StrUtil.isNotBlank(params.get("toStatus")), "to_status", params.get("toStatus"))
                .orderByDesc("create_time");
    }

    @Override
    @PostMapping
    public R<Long> save(@RequestBody OrderLog entity) {
        throw new BizException("订单日志不可修改");
    }

    @Override
    @PutMapping
    public R<Void> update(@RequestBody OrderLog entity) {
        throw new BizException("订单日志不可修改");
    }

    @Override
    @DeleteMapping("/{id}")
    public R<Void> remove(@PathVariable Long id) {
        throw new BizException("订单日志不可修改");
    }

    @Override
    @DeleteMapping("/batch")
    public R<Void> removeBatch(@RequestBody List<Long> ids) {
        throw new BizException("订单日志不可修改");
    }
}
