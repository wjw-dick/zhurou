package com.zhushi.cms.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.cms.entity.CmsCategory;
import com.zhushi.cms.mapper.CmsCategoryMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * CMS 栏目服务
 */
@Service
public class CmsCategoryService extends ServiceImpl<CmsCategoryMapper, CmsCategory> {

    /** 启用中的栏目（下拉） */
    public List<CmsCategory> listEnabled() {
        return list(new LambdaQueryWrapper<CmsCategory>()
                .eq(CmsCategory::getStatus, 1)
                .orderByAsc(CmsCategory::getSort));
    }
}
