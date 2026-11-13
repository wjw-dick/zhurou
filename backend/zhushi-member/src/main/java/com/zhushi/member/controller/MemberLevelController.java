package com.zhushi.member.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.member.entity.MemberLevel;
import com.zhushi.member.service.MemberLevelService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 会员等级管理
 */
@Tag(name = "会员等级")
@RestController
@RequestMapping("/member/level")
public class MemberLevelController extends BaseController<MemberLevelService, MemberLevel> {

    private final MemberLevelService memberLevelService;

    public MemberLevelController(MemberLevelService memberLevelService, PermChecker permChecker) {
        super(permChecker);
        this.memberLevelService = memberLevelService;
    }

    @Override
    protected MemberLevelService service() {
        return memberLevelService;
    }

    @Override
    protected String permPrefix() {
        return "member:level";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<MemberLevel> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByAsc("level");
    }

    /** 启用等级下拉 */
    @RequiresPerm("")
    @GetMapping("/options")
    public R<List<MemberLevel>> options() {
        return R.ok(memberLevelService.listEnabled());
    }
}
