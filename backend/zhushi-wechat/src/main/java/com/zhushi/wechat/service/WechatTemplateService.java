package com.zhushi.wechat.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.wechat.entity.WechatTemplate;
import com.zhushi.wechat.mapper.WechatTemplateMapper;
import org.springframework.stereotype.Service;

/**
 * 模板消息配置服务
 */
@Service
public class WechatTemplateService extends ServiceImpl<WechatTemplateMapper, WechatTemplate> {
}
