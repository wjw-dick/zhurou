package com.zhushi.cms.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

/**
 * CMS 文章 / 资讯 / 品牌故事 / 案例 / 单页
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("cms_article")
public class CmsArticle extends BaseEntity {

    private Long categoryId;
    private String title;
    private String titleEn;
    private String summary;
    private String summaryEn;
    /** 富文本(WangEditor) */
    private String content;
    /** 英文富文本 */
    private String contentEn;
    private String cover;
    private String author;
    private String source;
    private String seoKeywords;
    private String seoDesc;
    /** NEWS资讯 / BRAND品牌故事 / CASE案例 / PAGE单页 */
    private String articleType;
    private Integer views;
    private Integer isTop;
    /** 1发布 0草稿 */
    private Integer status;
    private LocalDateTime publishTime;
}
