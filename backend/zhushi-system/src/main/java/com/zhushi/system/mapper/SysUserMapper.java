package com.zhushi.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zhushi.system.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SysUserMapper extends BaseMapper<SysUser> {

    /** 查询用户拥有的权限标识 */
    @Select("""
            SELECT DISTINCT m.perm FROM sys_menu m
            JOIN sys_role_menu rm ON rm.menu_id = m.id
            JOIN sys_user_role ur ON ur.role_id = rm.role_id
            WHERE ur.user_id = #{userId} AND m.perm IS NOT NULL AND m.perm <> ''
              AND m.status = 1 AND m.deleted = 0
            """)
    List<String> selectPermsByUserId(@Param("userId") Long userId);

    /** 查询用户角色编码 */
    @Select("""
            SELECT r.code FROM sys_role r
            JOIN sys_user_role ur ON ur.role_id = r.id
            WHERE ur.user_id = #{userId} AND r.status = 1 AND r.deleted = 0
            """)
    List<String> selectRoleCodesByUserId(@Param("userId") Long userId);
}
