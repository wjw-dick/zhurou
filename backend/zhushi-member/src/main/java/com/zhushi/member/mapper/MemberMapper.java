package com.zhushi.member.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zhushi.member.entity.Member;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper extends BaseMapper<Member> {
}
