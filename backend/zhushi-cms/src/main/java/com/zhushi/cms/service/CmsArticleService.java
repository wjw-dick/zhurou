package com.zhushi.cms.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.cms.entity.CmsArticle;
import com.zhushi.cms.mapper.CmsArticleMapper;
import com.zhushi.common.exception.BizException;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * CMS 文章服务
 */
@Service
public class CmsArticleService extends ServiceImpl<CmsArticleMapper, CmsArticle> {

    /** 置为已发布并记录发布时间 */
    public void publish(Long id) {
        CmsArticle article = getById(id);
        if (article == null) {
            throw new BizException("文章不存在");
        }
        CmsArticle update = new CmsArticle();
        update.setId(id);
        update.setStatus(1);
        update.setPublishTime(LocalDateTime.now());
        updateById(update);
    }
}
