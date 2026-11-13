package com.zhushi.wechat.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.wechat.entity.WechatTemplate;
import com.zhushi.wechat.service.WechatTemplateService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 模板消息配置（超管全量维护）
 */
@Tag(name = "模板消息")
@RestController
@RequestMapping("/wechat/template")
public class WechatTemplateController extends BaseController<WechatTemplateService, WechatTemplate> {

    private final WechatTemplateService templateService;

    public WechatTemplateController(WechatTemplateService templateService, PermChecker permChecker) {
        super(permChecker);
        this.templateService = templateService;
    }

    @Override
    protected WechatTemplateService service() {
        return templateService;
    }

    @Override
    protected String permPrefix() {
        return "wechat:template";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"biz_type", "title", "template_id"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<WechatTemplate> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("bizType")), "biz_type", params.get("bizType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByAsc("id");
    }
}
