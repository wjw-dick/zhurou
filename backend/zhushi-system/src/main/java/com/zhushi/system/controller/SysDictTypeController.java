package com.zhushi.system.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.system.entity.SysDictType;
import com.zhushi.system.service.SysDictTypeService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@Tag(name = "字典类型")
@RestController
@RequestMapping("/system/dict/type")
public class SysDictTypeController extends BaseController<SysDictTypeService, SysDictType> {

    private final SysDictTypeService dictTypeService;

    public SysDictTypeController(SysDictTypeService dictTypeService, PermChecker permChecker) {
        super(permChecker);
        this.dictTypeService = dictTypeService;
    }

    @Override
    protected SysDictTypeService service() {
        return dictTypeService;
    }

    @Override
    protected String permPrefix() {
        return "sys:dict";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"code", "name"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SysDictType> wrapper) {
    }

    @RequiresPerm("sys:dict:list")
    @GetMapping("/options")
    public R<List<SysDictType>> options() {
        return R.ok(dictTypeService.list(new QueryWrapper<SysDictType>().eq("status", 1).orderByAsc("sort")));
    }
}
