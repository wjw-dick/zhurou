package com.zhushi.order.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.order.entity.OrderItem;
import com.zhushi.order.mapper.OrderItemMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderItemService extends ServiceImpl<OrderItemMapper, OrderItem> {

    /** 查询指定订单的明细 */
    public List<OrderItem> listByOrderId(Long orderId) {
        return list(new LambdaQueryWrapper<OrderItem>()
                .eq(OrderItem::getOrderId, orderId)
                .orderByAsc(OrderItem::getId));
    }
}
