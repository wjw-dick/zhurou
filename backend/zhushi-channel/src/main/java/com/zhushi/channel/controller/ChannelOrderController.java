package com.zhushi.channel.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.channel.entity.ChannelOrder;
import com.zhushi.channel.service.ChannelOrderService;
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

import java.util.Map;

/**
 * 渠道报单审核（超管全量维护）
 */
@Tag(name = "渠道报单审核")
@RestController
@RequestMapping("/channel/order")
public class ChannelOrderController extends BaseController<ChannelOrderService, ChannelOrder> {

    private final ChannelOrderService channelOrderService;

    public ChannelOrderController(ChannelOrderService channelOrderService, PermChecker permChecker) {
        super(permChecker);
        this.channelOrderService = channelOrderService;
    }

    @Override
    protected ChannelOrderService service() {
        return channelOrderService;
    }

    @Override
    protected String permPrefix() {
        return "channel:order";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"report_no", "order_no"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<ChannelOrder> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("channelId")), "channel_id", params.get("channelId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    /** 报单审核：通过时按规则计算佣金 */
    @OperationLog(module = "渠道报单", action = "审核")
    @RequiresPerm("channel:order:audit")
    @PutMapping("/{id}/audit")
    public R<Void> audit(@PathVariable Long id,
                         @RequestParam String status,
                         @RequestParam(required = false) String auditRemark) {
        channelOrderService.audit(id, status, auditRemark);
        return R.ok("审核完成", null);
    }
}
