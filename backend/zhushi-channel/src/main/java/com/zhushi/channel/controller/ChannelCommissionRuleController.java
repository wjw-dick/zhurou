package com.zhushi.channel.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.channel.entity.ChannelCommissionRule;
import com.zhushi.channel.service.ChannelCommissionRuleService;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 佣金规则（超管全量维护）
 */
@Tag(name = "渠道佣金规则")
@RestController
@RequestMapping("/channel/rule")
public class ChannelCommissionRuleController
        extends BaseController<ChannelCommissionRuleService, ChannelCommissionRule> {

    private final ChannelCommissionRuleService ruleService;

    public ChannelCommissionRuleController(ChannelCommissionRuleService ruleService, PermChecker permChecker) {
        super(permChecker);
        this.ruleService = ruleService;
    }

    @Override
    protected ChannelCommissionRuleService service() {
        return ruleService;
    }

    @Override
    protected String permPrefix() {
        return "channel:rule";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<ChannelCommissionRule> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("channelId")), "channel_id", params.get("channelId"))
                .eq(StrUtil.isNotBlank(params.get("bizType")), "biz_type", params.get("bizType"))
                .eq(StrUtil.isNotBlank(params.get("level")), "level", params.get("level"))
                .orderByAsc("id");
    }
}
