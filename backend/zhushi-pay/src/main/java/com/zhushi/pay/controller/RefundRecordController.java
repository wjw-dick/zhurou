package com.zhushi.pay.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.pay.entity.RefundRecord;
import com.zhushi.pay.service.RefundRecordService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.Map;

/**
 * 退款记录
 */
@Tag(name = "退款记录")
@RestController
@RequestMapping("/pay/refund")
public class RefundRecordController extends BaseController<RefundRecordService, RefundRecord> {

    private final RefundRecordService refundRecordService;

    public RefundRecordController(RefundRecordService refundRecordService, PermChecker permChecker) {
        super(permChecker);
        this.refundRecordService = refundRecordService;
    }

    @Override
    protected RefundRecordService service() {
        return refundRecordService;
    }

    @Override
    protected String permPrefix() {
        return "order:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"refund_no", "order_no"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<RefundRecord> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("orderId")), "order_id", params.get("orderId"))
                .eq(StrUtil.isNotBlank(params.get("aftersaleId")), "aftersale_id", params.get("aftersaleId"))
                .eq(StrUtil.isNotBlank(params.get("refundType")), "refund_type", params.get("refundType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    /** 申请退款 */
    @OperationLog(module = "退款记录", action = "申请退款")
    @RequiresPerm("order:aftersale:refund")
    @PostMapping("/apply")
    public R<RefundRecord> apply(@RequestParam(required = false) Long orderId,
                                 @RequestParam(required = false) BigDecimal amount,
                                 @RequestParam(required = false) String refundType) {
        return R.ok(refundRecordService.apply(orderId, amount, refundType));
    }
}
