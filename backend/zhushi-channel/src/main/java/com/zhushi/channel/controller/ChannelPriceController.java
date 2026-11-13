package com.zhushi.channel.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.channel.entity.ChannelPrice;
import com.zhushi.channel.service.ChannelPriceService;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 渠道专属价（超管全量维护）
 */
@Tag(name = "渠道专属价")
@RestController
@RequestMapping("/channel/price")
public class ChannelPriceController extends BaseController<ChannelPriceService, ChannelPrice> {

    private final ChannelPriceService channelPriceService;

    public ChannelPriceController(ChannelPriceService channelPriceService, PermChecker permChecker) {
        super(permChecker);
        this.channelPriceService = channelPriceService;
    }

    @Override
    protected ChannelPriceService service() {
        return channelPriceService;
    }

    @Override
    protected String permPrefix() {
        return "channel:price";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<ChannelPrice> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("channelId")), "channel_id", params.get("channelId"))
                .eq(StrUtil.isNotBlank(params.get("productId")), "product_id", params.get("productId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }
}
