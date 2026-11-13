package com.zhushi.order.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.security.LoginUser;
import com.zhushi.common.security.UserContext;
import com.zhushi.order.entity.OrderLog;
import com.zhushi.order.mapper.OrderLogMapper;
import org.springframework.stereotype.Service;

/**
 * 订单状态日志：仅由业务流程写入，不提供修改入口
 */
@Service
public class OrderLogService extends ServiceImpl<OrderLogMapper, OrderLog> {

    /**
     * 记录一条订单状态流转日志
     */
    public void record(Long orderId, String orderNo, String fromStatus, String toStatus, String remark) {
        if (orderId == null) {
            throw new BizException("订单ID不能为空");
        }
        OrderLog log = new OrderLog();
        log.setOrderId(orderId);
        log.setOrderNo(orderNo);
        log.setFromStatus(fromStatus);
        log.setToStatus(toStatus);
        log.setOperator(currentOperator());
        log.setRemark(remark);
        save(log);
    }

    /** 当前操作人，未登录时记为 SYSTEM */
    private String currentOperator() {
        LoginUser user = UserContext.get();
        if (user == null) {
            return "SYSTEM";
        }
        return user.getUsername() == null ? "SYSTEM" : user.getUsername();
    }
}
