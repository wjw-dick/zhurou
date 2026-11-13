package com.zhushi.channel.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.channel.entity.ChannelSettlement;
import com.zhushi.channel.service.ChannelSettlementService;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.Map;

/**
 * 渠道结算（超管全量维护）
 */
@Tag(name = "渠道结算")
@RestController
@RequestMapping("/channel/settlement")
public class ChannelSettlementController extends BaseController<ChannelSettlementService, ChannelSettlement> {

    private final ChannelSettlementService settlementService;

    public ChannelSettlementController(ChannelSettlementService settlementService, PermChecker permChecker) {
        super(permChecker);
        this.settlementService = settlementService;
    }

    @Override
    protected ChannelSettlementService service() {
        return settlementService;
    }

    @Override
    protected String permPrefix() {
        return "channel:settlement";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"settle_no"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<ChannelSettlement> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("channelId")), "channel_id", params.get("channelId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    @OperationLog(module = "渠道结算", action = "确认")
    @RequiresPerm("channel:settlement:generate")
    @PutMapping("/{id}/confirm")
    public R<Void> confirm(@PathVariable Long id) {
        settlementService.confirm(id);
        return R.ok();
    }

    @OperationLog(module = "渠道结算", action = "打款")
    @RequiresPerm("channel:settlement:pay")
    @PutMapping("/{id}/pay")
    public R<Void> pay(@PathVariable Long id, @RequestParam(required = false) BigDecimal paidAmount) {
        settlementService.pay(id, paidAmount);
        return R.ok("打款完成", null);
    }
}
