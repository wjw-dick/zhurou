package com.zhushi.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.system.entity.SysI18n;
import com.zhushi.system.mapper.SysI18nMapper;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 多语言词条服务
 */
@Service
public class SysI18nService extends ServiceImpl<SysI18nMapper, SysI18n> {

    /** 前端按语言取词条包 */
    public Map<String, String> bundle(String langCode) {
        List<SysI18n> list = list(new LambdaQueryWrapper<SysI18n>().eq(SysI18n::getLangCode, langCode));
        return list.stream().collect(Collectors.toMap(
                i -> i.getModule() + "." + i.getI18nKey(),
                SysI18n::getI18nValue, (a, b) -> a, LinkedHashMap::new));
    }
}
