package com.zhushi.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zhushi.system.entity.SysMenu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SysMenuMapper extends BaseMapper<SysMenu> {

    /** 按用户查询有权限的菜单（超管走全量查询，不调此方法） */
    @Select("""
            SELECT DISTINCT m.* FROM sys_menu m
            JOIN sys_role_menu rm ON rm.menu_id = m.id
            JOIN sys_user_role ur ON ur.role_id = rm.role_id
            WHERE ur.user_id = #{userId} AND m.status = 1 AND m.deleted = 0 AND m.platform = #{platform}
            ORDER BY m.sort ASC, m.id ASC
            """)
    List<SysMenu> selectMenusByUserId(@Param("userId") Long userId, @Param("platform") String platform);
}
