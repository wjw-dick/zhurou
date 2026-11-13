package com.zhushi.reserve.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.reserve.entity.ReserveConfig;
import com.zhushi.reserve.service.ReserveConfigService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 鲜肉预订配置：分割加工费 / 损耗率 / 截止时间
 */
@Tag(name = "预订配置")
@RestController
@RequestMapping("/reserve/config")
public class ReserveConfigController extends BaseController<ReserveConfigService, ReserveConfig> {

    private final ReserveConfigService reserveConfigService;

    public ReserveConfigController(ReserveConfigService reserveConfigService, PermChecker permChecker) {
        super(permChecker);
        this.reserveConfigService = reserveConfigService;
    }

    @Override
    protected ReserveConfigService service() {
        return reserveConfigService;
    }

    @Override
    protected String permPrefix() {
        return "reserve:config";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<ReserveConfig> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByAsc("store_id");
    }

    /** 按门店查询预订配置 */
    @RequiresPerm("reserve:config:list")
    @GetMapping("/by-store")
    public R<ReserveConfig> byStore(@RequestParam Long storeId) {
        return R.ok(reserveConfigService.getByStoreId(storeId));
    }
}
