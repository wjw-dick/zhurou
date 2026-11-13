package com.zhushi.order.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zhushi.order.entity.OrderItem;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderItemMapper extends BaseMapper<OrderItem> {
}
