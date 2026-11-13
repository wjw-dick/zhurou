package com.zhushi.system.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.system.entity.SysDictData;
import com.zhushi.system.service.SysDictDataService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@Tag(name = "字典数据")
@RestController
@RequestMapping("/system/dict/data")
public class SysDictDataController extends BaseController<SysDictDataService, SysDictData> {

    private final SysDictDataService dictDataService;

    public SysDictDataController(SysDictDataService dictDataService, PermChecker permChecker) {
        super(permChecker);
        this.dictDataService = dictDataService;
    }

    @Override
    protected SysDictDataService service() {
        return dictDataService;
    }

    @Override
    protected String permPrefix() {
        return "sys:dict";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"label", "value"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SysDictData> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("dictCode")), "dict_code", params.get("dictCode"));
    }

    /** 按编码取字典项（任意登录用户可用，供表单下拉） */
    @RequiresPerm("")
    @GetMapping("/by/{dictCode}")
    public R<List<SysDictData>> byCode(@PathVariable String dictCode) {
        return R.ok(dictDataService.listByCode(dictCode));
    }
}
