package com.zhushi.wechat.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.wechat.entity.WechatMenuPublish;
import com.zhushi.wechat.mapper.WechatMenuPublishMapper;
import org.springframework.stereotype.Service;

/**
 * 公众号菜单发布服务
 * 说明：真实环境需调用微信「创建自定义菜单」接口（cgi-bin/menu/create），
 * 此处保存发布快照并记录结果，便于后台可维护与回滚。
 */
@Service
public class WechatMenuPublishService extends ServiceImpl<WechatMenuPublishMapper, WechatMenuPublish> {

    public WechatMenuPublish latest() {
        return getOne(new LambdaQueryWrapper<WechatMenuPublish>()
                .orderByDesc(WechatMenuPublish::getId)
                .last("limit 1"), false);
    }

    public WechatMenuPublish publish(String menuJson, String operator) {
        WechatMenuPublish record = new WechatMenuPublish();
        record.setMenuJson(menuJson);
        record.setPublishUser(operator);
        record.setStatus("SUCCESS");
        record.setMessage("已生成发布快照（接入微信后调用 cgi-bin/menu/create 生效）");
        save(record);
        return record;
    }
}
