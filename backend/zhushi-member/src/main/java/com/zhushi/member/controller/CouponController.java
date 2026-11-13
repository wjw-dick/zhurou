package com.zhushi.member.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.member.entity.Coupon;
import com.zhushi.member.service.CouponService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 优惠券管理
 */
@Tag(name = "优惠券管理")
@RestController
@RequestMapping("/member/coupon")
public class CouponController extends BaseController<CouponService, Coupon> {

    private final CouponService couponService;

    public CouponController(CouponService couponService, PermChecker permChecker) {
        super(permChecker);
        this.couponService = couponService;
    }

    @Override
    protected CouponService service() {
        return couponService;
    }

    @Override
    protected String permPrefix() {
        return "member:coupon";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<Coupon> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("couponType")), "coupon_type", params.get("couponType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }
}
