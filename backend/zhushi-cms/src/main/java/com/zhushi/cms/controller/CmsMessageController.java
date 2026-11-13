package com.zhushi.cms.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.cms.entity.CmsMessage;
import com.zhushi.cms.service.CmsMessageService;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 留言 / 团购咨询 管理
 */
@Tag(name = "留言管理")
@RestController
@RequestMapping("/cms/message")
public class CmsMessageController extends BaseController<CmsMessageService, CmsMessage> {

    private final CmsMessageService cmsMessageService;

    public CmsMessageController(CmsMessageService cmsMessageService, PermChecker permChecker) {
        super(permChecker);
        this.cmsMessageService = cmsMessageService;
    }

    @Override
    protected CmsMessageService service() {
        return cmsMessageService;
    }

    @Override
    protected String permPrefix() {
        return "cms:message";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name", "phone", "company", "content"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<CmsMessage> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("msgType")), "msg_type", params.get("msgType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    /** 处理留言 */
    @OperationLog(module = "留言管理", action = "处理留言")
    @RequiresPerm("cms:message:handle")
    @PutMapping("/{id}/handle")
    public R<Void> handle(@PathVariable Long id,
                          @RequestParam String status,
                          @RequestParam(required = false) String remark) {
        cmsMessageService.handle(id, status, remark);
        return R.ok("处理完成", null);
    }
}
