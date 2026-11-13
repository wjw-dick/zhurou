package com.zhushi.reserve.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.reserve.entity.ReserveConfig;
import com.zhushi.reserve.mapper.ReserveConfigMapper;
import org.springframework.stereotype.Service;

/**
 * 鲜肉预订配置：一店一份配置
 */
@Service
public class ReserveConfigService extends ServiceImpl<ReserveConfigMapper, ReserveConfig> {

    /** 按门店查询预订配置 */
    public ReserveConfig getByStoreId(Long storeId) {
        if (storeId == null) {
            return null;
        }
        return getOne(new LambdaQueryWrapper<ReserveConfig>()
                .eq(ReserveConfig::getStoreId, storeId)
                .last("limit 1"), false);
    }
}
