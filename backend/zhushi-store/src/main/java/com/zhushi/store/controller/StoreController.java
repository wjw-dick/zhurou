package com.zhushi.store.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.store.entity.Store;
import com.zhushi.store.service.StoreService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 门店管理（超管全量维护）
 */
@Tag(name = "门店管理")
@RestController
@RequestMapping("/store/info")
public class StoreController extends BaseController<StoreService, Store> {

    private final StoreService storeService;

    public StoreController(StoreService storeService, PermChecker permChecker) {
        super(permChecker);
        this.storeService = storeService;
    }

    @Override
    protected StoreService service() {
        return storeService;
    }

    @Override
    protected String permPrefix() {
        return "store:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name", "code", "phone", "address"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<Store> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .eq(StrUtil.isNotBlank(params.get("city")), "city", params.get("city"))
                .orderByAsc("sort");
    }

    /** 启用门店下拉 */
    @RequiresPerm("")
    @GetMapping("/options")
    public R<List<Store>> options() {
        return R.ok(storeService.listEnabled());
    }
}
