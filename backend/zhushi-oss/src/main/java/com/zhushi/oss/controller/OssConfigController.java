package com.zhushi.oss.controller;

import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.oss.entity.OssConfig;
import com.zhushi.oss.service.OssConfigService;
import com.zhushi.oss.storage.OssStorageFactory;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 对象存储配置页（超管全量维护）：5 卡片单选 → 滑出表单 → 连接测试 → 保存
 */
@Tag(name = "对象存储配置")
@RestController
@RequestMapping("/oss/config")
public class OssConfigController extends BaseController<OssConfigService, OssConfig> {

    private final OssConfigService ossConfigService;

    public OssConfigController(OssConfigService ossConfigService, PermChecker permChecker) {
        super(permChecker);
        this.ossConfigService = ossConfigService;
    }

    @Override
    protected OssConfigService service() {
        return ossConfigService;
    }

    @Override
    protected String permPrefix() {
        return "oss:config";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"driver", "test_result"};
    }

    /** 可选驱动列表 */
    @RequiresPerm("oss:config:list")
    @GetMapping("/drivers")
    public R<List<String>> drivers() {
        return R.ok(OssStorageFactory.DRIVERS);
    }

    /** 当前启用配置 */
    @RequiresPerm("oss:config:list")
    @GetMapping("/current")
    public R<OssConfig> current() {
        OssConfig config = ossConfigService.currentConfig();
        if (config.getId() != null) {
            config.setConfigJson(ossConfigService.plainConfigJson(config.getId()));
        }
        return R.ok(config);
    }

    /** 连接测试 */
    @Operation(summary = "连接测试")
    @OperationLog(module = "对象存储", action = "连接测试")
    @RequiresPerm("oss:config:test")
    @PostMapping("/test")
    public R<Boolean> test(@RequestBody OssConfig config) {
        return R.ok("测试完成", ossConfigService.test(config));
    }

    /** 保存配置（自动加密敏感参数） */
    @Operation(summary = "保存配置")
    @OperationLog(module = "对象存储", action = "保存配置")
    @RequiresPerm("oss:config:edit")
    @PutMapping("/save")
    public R<Void> saveConfig(@RequestBody OssConfig config) {
        ossConfigService.saveConfig(config);
        return R.ok("保存成功", null);
    }
}
