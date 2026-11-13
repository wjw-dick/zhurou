package com.zhushi.store.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.store.entity.Store;
import com.zhushi.store.mapper.StoreMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StoreService extends ServiceImpl<StoreMapper, Store> {

    public List<Store> listEnabled() {
        return list(new LambdaQueryWrapper<Store>()
                .eq(Store::getStatus, 1)
                .orderByAsc(Store::getSort));
    }
}
