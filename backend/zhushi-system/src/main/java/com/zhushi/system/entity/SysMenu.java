package com.zhushi.system.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import com.zhushi.common.core.TreeNode;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

/**
 * 菜单：支持五套平台（后台/官网/公众号/小程序 tabBar/H5），可增删改 + 拖拽排序
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_menu")
public class SysMenu extends BaseEntity implements TreeNode<SysMenu> {

    private Long parentId;
    /** ADMIN / PC / WECHAT / MINIAPP / H5 */
    private String platform;
    /** DIR 目录 / MENU 菜单 / BUTTON 按钮 / LINK 外链 */
    private String menuType;
    private String name;
    private String nameEn;
    private String path;
    private String component;
    private String icon;
    private String perm;
    private String linkUrl;
    /** 公众号菜单类型 PAGE / PAGEVIEW / MINIAPP / WEBVIEW */
    private String linkType;
    private String appid;
    private String pagePath;
    private Integer sort;
    private Integer visible;
    private Integer keepAlive;
    private Integer status;
    private String remark;

    @TableField(exist = false)
    private List<SysMenu> children = new ArrayList<>();
}
