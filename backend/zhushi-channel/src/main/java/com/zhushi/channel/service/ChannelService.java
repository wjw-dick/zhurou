package com.zhushi.channel.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.channel.entity.Channel;
import com.zhushi.channel.mapper.ChannelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 渠道商服务
 */
@Service
public class ChannelService extends ServiceImpl<ChannelMapper, Channel> {

    public List<Channel> listEnabled() {
        return list(new LambdaQueryWrapper<Channel>()
                .eq(Channel::getStatus, 1)
                .orderByAsc(Channel::getId));
    }
}
