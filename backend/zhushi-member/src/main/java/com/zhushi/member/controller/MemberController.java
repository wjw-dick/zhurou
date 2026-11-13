package com.zhushi.member.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.member.entity.Member;
import com.zhushi.member.entity.MemberBalanceLog;
import com.zhushi.member.entity.MemberPointsLog;
import com.zhushi.member.service.MemberService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 会员管理：储值 / 积分 / 流水
 */
@Tag(name = "会员管理")
@RestController
@RequestMapping("/member/info")
public class MemberController extends BaseController<MemberService, Member> {

    private final MemberService memberService;

    public MemberController(MemberService memberService, PermChecker permChecker) {
        super(permChecker);
        this.memberService = memberService;
    }

    @Override
    protected MemberService service() {
        return memberService;
    }

    @Override
    protected String permPrefix() {
        return "member:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"nickname", "phone", "unionid"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<Member> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("levelId")), "level_id", params.get("levelId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }

    /** 会员储值 */
    @OperationLog(module = "会员管理", action = "会员储值")
    @RequiresPerm("member:info:recharge")
    @PutMapping("/{id}/recharge")
    public R<Void> recharge(@PathVariable Long id,
                            @RequestParam BigDecimal amount,
                            @RequestParam(required = false) String remark) {
        memberService.recharge(id, amount, remark);
        return R.ok("储值成功", null);
    }

    /** 调整积分 */
    @OperationLog(module = "会员管理", action = "调整积分")
    @RequiresPerm("member:info:points")
    @PutMapping("/{id}/points")
    public R<Void> adjustPoints(@PathVariable Long id,
                                @RequestParam Integer points,
                                @RequestParam(required = false) String remark) {
        memberService.adjustPoints(id, points, remark);
        return R.ok("积分调整成功", null);
    }

    /** 会员储值流水 */
    @RequiresPerm("member:info:list")
    @GetMapping("/{id}/balance-logs")
    public R<List<MemberBalanceLog>> balanceLogs(@PathVariable Long id) {
        return R.ok(memberService.balanceLogs(id));
    }

    /** 会员积分流水 */
    @RequiresPerm("member:info:list")
    @GetMapping("/{id}/points-logs")
    public R<List<MemberPointsLog>> pointsLogs(@PathVariable Long id) {
        return R.ok(memberService.pointsLogs(id));
    }
}
