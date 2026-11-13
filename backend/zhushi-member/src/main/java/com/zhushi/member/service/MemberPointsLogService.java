package com.zhushi.member.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.member.entity.MemberPointsLog;
import com.zhushi.member.mapper.MemberPointsLogMapper;
import org.springframework.stereotype.Service;

/**
 * 积分流水服务（仅内部写入，对外只读）
 */
@Service
public class MemberPointsLogService extends ServiceImpl<MemberPointsLogMapper, MemberPointsLog> {
}
