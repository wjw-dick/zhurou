package com.zhushi.member.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.member.entity.MemberBalanceLog;
import com.zhushi.member.mapper.MemberBalanceLogMapper;
import org.springframework.stereotype.Service;

/**
 * 储值流水服务（仅内部写入，对外只读）
 */
@Service
public class MemberBalanceLogService extends ServiceImpl<MemberBalanceLogMapper, MemberBalanceLog> {
}
