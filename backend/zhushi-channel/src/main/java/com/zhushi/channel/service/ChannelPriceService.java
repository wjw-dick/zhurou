package com.zhushi.channel.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.channel.entity.ChannelPrice;
import com.zhushi.channel.mapper.ChannelPriceMapper;
import org.springframework.stereotype.Service;

/**
 * 渠道专属价服务
 */
@Service
public class ChannelPriceService extends ServiceImpl<ChannelPriceMapper, ChannelPrice> {
}
