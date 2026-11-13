package com.zhushi.system.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.util.CryptoUtil;
import com.zhushi.system.entity.SysConfig;
import com.zhushi.system.mapper.SysConfigMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 系统参数服务：可视化配置，加密参数掩码展示
 */
@Service
@RequiredArgsConstructor
public class SysConfigService extends ServiceImpl<SysConfigMapper, SysConfig> {

    private final CryptoUtil cryptoUtil;

    /** 按分组返回（含掩码） */
    public Map<String, List<SysConfig>> grouped() {
        List<SysConfig> all = list(new LambdaQueryWrapper<SysConfig>()
                .orderByAsc(SysConfig::getGroupCode).orderByAsc(SysConfig::getSort));
        all.forEach(this::maskIfEncrypted);
        return all.stream().collect(Collectors.groupingBy(SysConfig::getGroupCode,
                LinkedHashMap::new, Collectors.toList()));
    }

    public Map<String, String> kv() {
        return list().stream().collect(Collectors.toMap(SysConfig::getConfigKey,
                c -> value(c.getConfigValue(), c.getEncrypted()), (a, b) -> a, LinkedHashMap::new));
    }

    public String getValue(String configKey) {
        SysConfig config = getOne(new LambdaQueryWrapper<SysConfig>().eq(SysConfig::getConfigKey, configKey), false);
        return config == null ? null : value(config.getConfigValue(), config.getEncrypted());
    }

    private String value(String raw, Integer encrypted) {
        return Integer.valueOf(1).equals(encrypted) ? cryptoUtil.decrypt(raw) : raw;
    }

    private void maskIfEncrypted(SysConfig config) {
        if (Integer.valueOf(1).equals(config.getEncrypted())) {
            config.setConfigValue(cryptoUtil.mask(cryptoUtil.decrypt(config.getConfigValue())));
        }
    }

    /** 保存单个参数（加密参数若为掩码则不改动） */
    public void saveValue(Long id, String value) {
        SysConfig config = getById(id);
        if (config == null) {
            throw new BizException("参数不存在");
        }
        if (config.getConfigKey() == null) {
            return;
        }
        if (Integer.valueOf(1).equals(config.getEncrypted())) {
            if (value == null || value.contains("****")) {
                return;
            }
            value = cryptoUtil.encrypt(value);
        }
        config.setConfigValue(value);
        updateById(config);
    }

    /** 批量保存 [{id, configValue}] */
    @Transactional(rollbackFor = Exception.class)
    public void saveBatchValues(List<Map<String, Object>> items) {
        if (items == null) {
            return;
        }
        for (Map<String, Object> item : items) {
            Object id = item.get("id");
            Object value = item.get("configValue");
            if (id != null) {
                saveValue(Long.valueOf(String.valueOf(id)), value == null ? null : String.valueOf(value));
            }
        }
    }

    /** 仅超管等已授权用户可读取明文（用于连接测试等场景） */
    public String getPlainValue(String configKey) {
        return getValue(configKey);
    }
}
