package com.zhushi.system.dto;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 前端动态路由
 */
@Data
public class RouteVO {

    private Long id;
    private String name;
    private String path;
    private String component;
    private Meta meta = new Meta();
    private List<RouteVO> children = new ArrayList<>();

    @Data
    public static class Meta {
        private String title;
        private String titleEn;
        private String icon;
        private boolean hidden;
        private boolean keepAlive = true;
        private String perm;
    }
}
