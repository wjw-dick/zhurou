package com.zhushi.order.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.util.BizNoUtil;
import com.zhushi.order.entity.OrderInfo;
import com.zhushi.order.mapper.OrderInfoMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

/**
 * 订单服务：下单 + 状态流转（每次流转写一条订单日志）
 */
@Service
@RequiredArgsConstructor
public class OrderInfoService extends ServiceImpl<OrderInfoMapper, OrderInfo> {

    /** 待支付 */
    public static final String STATUS_UNPAID = "UNPAID";
    /** 待备货 */
    public static final String STATUS_PREPARING = "PREPARING";
    /** 配送中 */
    public static final String STATUS_DELIVERING = "DELIVERING";
    /** 已完成 */
    public static final String STATUS_COMPLETED = "COMPLETED";
    /** 已取消 */
    public static final String STATUS_CANCELLED = "CANCELLED";

    /** 允许流转的终态，禁止再次流转 */
    private static final List<String> FINAL_STATUS = Collections.unmodifiableList(
            List.of(STATUS_COMPLETED, STATUS_CANCELLED));

    private final OrderLogService orderLogService;

    /** 下单：生成订单号后落库 */
    @Transactional(rollbackFor = Exception.class)
    public Long createOrder(OrderInfo order) {
        if (order.getOrderNo() == null || order.getOrderNo().isBlank()) {
            order.setOrderNo(BizNoUtil.next("ZS"));
        }
        if (order.getStatus() == null || order.getStatus().isBlank()) {
            order.setStatus(STATUS_UNPAID);
        }
        save(order);
        orderLogService.record(order.getId(), order.getOrderNo(), null, order.getStatus(), "创建订单");
        return order.getId();
    }

    /** 备货：UNPAID/其他可流转状态 → PREPARING */
    @Transactional(rollbackFor = Exception.class)
    public void prepare(Long id) {
        changeStatus(id, STATUS_PREPARING, "订单备货", null);
    }

    /** 发货：→ DELIVERING */
    @Transactional(rollbackFor = Exception.class)
    public void deliver(Long id) {
        changeStatus(id, STATUS_DELIVERING, "订单发货", null);
    }

    /** 完成：→ COMPLETED */
    @Transactional(rollbackFor = Exception.class)
    public void finish(Long id) {
        changeStatus(id, STATUS_COMPLETED, "订单完成", null);
    }

    /** 取消：→ CANCELLED，记录取消原因 */
    @Transactional(rollbackFor = Exception.class)
    public void cancel(Long id, String reason) {
        changeStatus(id, STATUS_CANCELLED, "订单取消", reason);
    }

    /**
     * 状态流转核心逻辑：校验订单、更新状态并写入流转日志
     */
    @Transactional(rollbackFor = Exception.class)
    public void changeStatus(Long id, String toStatus, String action, String reason) {
        OrderInfo order = getById(id);
        if (order == null) {
            throw new BizException("订单不存在");
        }
        String fromStatus = order.getStatus();
        if (toStatus.equals(fromStatus)) {
            throw new BizException("订单已处于该状态，无需重复操作");
        }
        if (FINAL_STATUS.contains(fromStatus)) {
            throw new BizException("订单已处于终态，不可再次流转");
        }
        OrderInfo update = new OrderInfo();
        update.setId(id);
        update.setStatus(toStatus);
        if (STATUS_CANCELLED.equals(toStatus)) {
            update.setCancelReason(reason);
        }
        if (STATUS_COMPLETED.equals(toStatus)) {
            update.setFinishTime(LocalDateTime.now());
        }
        updateById(update);
        orderLogService.record(id, order.getOrderNo(), fromStatus, toStatus, action + (reason == null ? "" : "：" + reason));
    }
}
