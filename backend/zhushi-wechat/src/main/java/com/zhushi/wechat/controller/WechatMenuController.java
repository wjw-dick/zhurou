package com.zhushi.wechat.controller;

import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.common.security.UserContext;
import com.zhushi.wechat.entity.WechatMenuPublish;
import com.zhushi.wechat.service.WechatMenuPublishService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 公众号菜单：发布快照与记录（菜单结构本身由「菜单维护 · 公众号」页编辑）
 */
@Tag(name = "公众号菜单")
@RestController
@RequestMapping("/wechat/menu")
public class WechatMenuController extends BaseController<WechatMenuPublishService, WechatMenuPublish> {

    private final WechatMenuPublishService publishService;

    public WechatMenuController(WechatMenuPublishService publishService, PermChecker permChecker) {
        super(permChecker);
        this.publishService = publishService;
    }

    @Override
    protected WechatMenuPublishService service() {
        return publishService;
    }

    @Override
    protected String permPrefix() {
        return "wechat:menu";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"publish_user"};
    }

    /** 最近一次发布快照 */
    @Operation(summary = "最近发布快照")
    @RequiresPerm("wechat:menu:list")
    @GetMapping("/latest")
    public R<WechatMenuPublish> latest() {
        return R.ok(publishService.latest());
    }

    /** 发布菜单（生成快照并记录） */
    @Operation(summary = "发布菜单")
    @OperationLog(module = "公众号菜单", action = "发布")
    @RequiresPerm("wechat:menu:publish")
    @PostMapping("/publish")
    public R<WechatMenuPublish> publish(@RequestBody Map<String, String> body) {
        String menuJson = body == null ? null : body.get("menuJson");
        String operator = UserContext.get() == null ? "system" : UserContext.get().getUsername();
        return R.ok("发布成功", publishService.publish(menuJson, operator));
    }
}
