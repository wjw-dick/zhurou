package com.zhushi.wechat.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.wechat.entity.WechatMsgLog;
import com.zhushi.wechat.mapper.WechatMsgLogMapper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 * 模板消息发送日志服务（只写入与查询）
 */
@Service
public class WechatMsgLogService extends ServiceImpl<WechatMsgLogMapper, WechatMsgLog> {

    @Async
    public void record(WechatMsgLog log) {
        save(log);
    }
}
