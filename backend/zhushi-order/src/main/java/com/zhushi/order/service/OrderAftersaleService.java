package com.zhushi.order.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.order.entity.OrderAftersale;
import com.zhushi.order.mapper.OrderAftersaleMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * 订单售后：支持审核流转
 */
@Service
public class OrderAftersaleService extends ServiceImpl<OrderAftersaleMapper, OrderAftersale> {

    /**
     * 售后审核：status=AGREED已同意 / REJECTED已拒绝 / DONE已完成
     */
    public void audit(Long id, String status, String remark) {
        OrderAftersale aftersale = getById(id);
        if (aftersale == null) {
            throw new BizException("售后单不存在");
        }
        if ("APPLYING".equals(status) || status == null || status.isBlank()) {
            throw new BizException("审核状态不合法");
        }
        OrderAftersale update = new OrderAftersale();
        update.setId(id);
        update.setStatus(status);
        update.setAuditRemark(remark);
        update.setAuditTime(LocalDateTime.now());
        updateById(update);
    }
}
