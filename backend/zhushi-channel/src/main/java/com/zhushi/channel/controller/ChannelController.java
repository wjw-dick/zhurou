package com.zhushi.channel.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.channel.entity.Channel;
import com.zhushi.channel.service.ChannelService;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 渠道商档案（超管全量维护）
 */
@Tag(name = "渠道商档案")
@RestController
@RequestMapping("/channel/info")
public class ChannelController extends BaseController<ChannelService, Channel> {

    private final ChannelService channelService;

    public ChannelController(ChannelService channelService, PermChecker permChecker) {
        super(permChecker);
        this.channelService = channelService;
    }

    @Override
    protected ChannelService service() {
        return channelService;
    }

    @Override
    protected String permPrefix() {
        return "channel:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name", "code", "contact", "phone"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<Channel> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("channelType")), "channel_type", params.get("channelType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .eq(StrUtil.isNotBlank(params.get("parentId")), "parent_id", params.get("parentId"))
                .orderByAsc("id");
    }

    @RequiresPerm("")
    @GetMapping("/options")
    public R<List<Channel>> options() {
        return R.ok(channelService.listEnabled());
    }
}
