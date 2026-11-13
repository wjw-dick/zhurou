package com.zhushi.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.system.entity.SysDictData;
import com.zhushi.system.mapper.SysDictDataMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SysDictDataService extends ServiceImpl<SysDictDataMapper, SysDictData> {

    public List<SysDictData> listByCode(String dictCode) {
        return list(new LambdaQueryWrapper<SysDictData>()
                .eq(SysDictData::getDictCode, dictCode)
                .eq(SysDictData::getStatus, 1)
                .orderByAsc(SysDictData::getSort));
    }
}
