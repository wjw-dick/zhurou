package com.zhushi.cms.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.cms.entity.CmsBanner;
import com.zhushi.cms.mapper.CmsBannerMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Banner 服务
 */
@Service
public class CmsBannerService extends ServiceImpl<CmsBannerMapper, CmsBanner> {

    /** 按位置查询启用中的 banner */
    public List<CmsBanner> listByPosition(String position) {
        return list(new LambdaQueryWrapper<CmsBanner>()
                .eq(CmsBanner::getStatus, 1)
                .eq(CmsBanner::getPosition, position)
                .orderByAsc(CmsBanner::getSort));
    }
}
