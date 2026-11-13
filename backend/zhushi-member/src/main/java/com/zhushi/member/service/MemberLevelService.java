package com.zhushi.member.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.member.entity.MemberLevel;
import com.zhushi.member.mapper.MemberLevelMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 会员等级服务
 */
@Service
public class MemberLevelService extends ServiceImpl<MemberLevelMapper, MemberLevel> {

    /** 启用中的会员等级（下拉） */
    public List<MemberLevel> listEnabled() {
        return list(new LambdaQueryWrapper<MemberLevel>()
                .eq(MemberLevel::getStatus, 1)
                .orderByAsc(MemberLevel::getLevel));
    }
}
