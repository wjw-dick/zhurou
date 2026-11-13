package com.zhushi.pay.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.pay.entity.PayRecord;
import com.zhushi.pay.service.PayRecordService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.Map;

/**
 * 支付记录
 */
@Tag(name = "支付记录")
@RestController
@RequestMapping("/pay/record")
public class PayRecordController extends BaseController<PayRecordService, PayRecord> {

    private final PayRecordService payRecordService;

    public PayRecordController(PayRecordService payRecordService, PermChecker permChecker) {
        super(permChecker);
        this.payRecordService = payRecordService;
    }

    @Override
    protected PayRecordService service() {
        return payRecordService;
    }

    @Override
    protected String permPrefix() {
        return "order:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"pay_no", "order_no", "transaction_id"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<PayRecord> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("orderId")), "order_id", params.get("orderId"))
                .eq(StrUtil.isNotBlank(params.get("memberId")), "member_id", params.get("memberId"))
                .eq(StrUtil.isNotBlank(params.get("payType")), "pay_type", params.get("payType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    /** 生成支付单（预支付） */
    @OperationLog(module = "支付记录", action = "预支付")
    @RequiresPerm("order:info:list")
    @PostMapping("/prepay")
    public R<PayRecord> prepay(@RequestParam(required = false) Long orderId,
                               @RequestParam(required = false) String orderNo,
                               @RequestParam(required = false) Long memberId,
                               @RequestParam(required = false) String payType,
                               @RequestParam(required = false) BigDecimal amount) {
        return R.ok(payRecordService.prepay(orderId, orderNo, memberId, payType, amount));
    }

    /** 模拟支付回调 */
    @OperationLog(module = "支付记录", action = "支付回调")
    @RequiresPerm("")
    @PostMapping("/notify")
    public R<PayRecord> notify(@RequestParam String payNo,
                               @RequestParam(required = false) String transactionId) {
        return R.ok(payRecordService.notify(payNo, transactionId));
    }
}
