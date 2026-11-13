package com.zhushi.wechat.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.security.PermChecker;
import com.zhushi.wechat.entity.WechatMsgLog;
import com.zhushi.wechat.service.WechatMsgLogService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 模板消息发送日志：仅可查询
 */
@Tag(name = "发送日志")
@RestController
@RequestMapping("/wechat/log")
public class WechatMsgLogController extends BaseController<WechatMsgLogService, WechatMsgLog> {

    private final WechatMsgLogService msgLogService;

    public WechatMsgLogController(WechatMsgLogService msgLogService, PermChecker permChecker) {
        super(permChecker);
        this.msgLogService = msgLogService;
    }

    @Override
    protected WechatMsgLogService service() {
        return msgLogService;
    }

    @Override
    protected String permPrefix() {
        return "wechat:log";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"openid", "biz_type", "template_id"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<WechatMsgLog> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("bizType")), "biz_type", params.get("bizType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    @Override
    @PostMapping
    public R<Long> save(@RequestBody WechatMsgLog entity) {
        throw new BizException("发送日志不可新增");
    }

    @Override
    @PutMapping
    public R<Void> update(@RequestBody WechatMsgLog entity) {
        throw new BizException("发送日志不可修改");
    }

    @Override
    @DeleteMapping("/{id}")
    public R<Void> remove(@PathVariable Long id) {
        throw new BizException("发送日志不可删除");
    }

    @Override
    @DeleteMapping("/batch")
    public R<Void> removeBatch(@RequestBody List<Long> ids) {
        throw new BizException("发送日志不可删除");
    }
}
