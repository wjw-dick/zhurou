package com.zhushi.member.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.security.PermChecker;
import com.zhushi.member.entity.MemberPointsLog;
import com.zhushi.member.service.MemberPointsLogService;
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
 * 积分流水：仅可查询，不可增删改（含超管）
 */
@Tag(name = "积分流水")
@RestController
@RequestMapping("/member/points")
public class MemberPointsLogController extends BaseController<MemberPointsLogService, MemberPointsLog> {

    private final MemberPointsLogService pointsLogService;

    public MemberPointsLogController(MemberPointsLogService pointsLogService, PermChecker permChecker) {
        super(permChecker);
        this.pointsLogService = pointsLogService;
    }

    @Override
    protected MemberPointsLogService service() {
        return pointsLogService;
    }

    @Override
    protected String permPrefix() {
        return "member:points";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"biz_no", "remark"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<MemberPointsLog> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("memberId")), "member_id", params.get("memberId"))
                .eq(StrUtil.isNotBlank(params.get("changeType")), "change_type", params.get("changeType"))
                .ge(StrUtil.isNotBlank(params.get("startTime")), "create_time", params.get("startTime"))
                .le(StrUtil.isNotBlank(params.get("endTime")), "create_time", params.get("endTime"))
                .orderByDesc("create_time");
    }

    @Override
    @PostMapping
    public R<Long> save(@RequestBody MemberPointsLog entity) {
        throw new BizException("积分流水不可修改");
    }

    @Override
    @PutMapping
    public R<Void> update(@RequestBody MemberPointsLog entity) {
        throw new BizException("积分流水不可修改");
    }

    @Override
    @DeleteMapping("/{id}")
    public R<Void> remove(@PathVariable Long id) {
        throw new BizException("积分流水不可修改");
    }

    @Override
    @DeleteMapping("/batch")
    public R<Void> removeBatch(@RequestBody List<Long> ids) {
        throw new BizException("积分流水不可修改");
    }
}
