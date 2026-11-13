package com.zhushi.member.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.member.entity.Coupon;
import com.zhushi.member.mapper.CouponMapper;
import org.springframework.stereotype.Service;

/**
 * 优惠券服务
 */
@Service
public class CouponService extends ServiceImpl<CouponMapper, Coupon> {
}
