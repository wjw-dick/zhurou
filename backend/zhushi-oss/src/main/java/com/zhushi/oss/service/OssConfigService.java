package com.zhushi.oss.service;

import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.util.CryptoUtil;
import com.zhushi.oss.entity.OssConfig;
import com.zhushi.oss.mapper.OssConfigMapper;
import com.zhushi.oss.storage.OssProperties;
import com.zhushi.oss.storage.OssStorage;
import com.zhushi.oss.storage.OssStorageFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 对象存储配置服务：驱动切换 + 参数加解密 + 连接测试
 */
@Service
@RequiredArgsConstructor
public class OssConfigService extends ServiceImpl<OssConfigMapper, OssConfig> {

    private final CryptoUtil cryptoUtil;

    /** 当前启用配置 */
    public OssConfig currentConfig() {
        OssConfig config = getOne(new LambdaQueryWrapper<OssConfig>()
                .eq(OssConfig::getIsDefault, 1)
                .eq(OssConfig::getStatus, 1)
                .orderByDesc(OssConfig::getId)
                .last("limit 1"), false);
        if (config == null) {
            config = new OssConfig();
            config.setDriver("LOCAL");
            config.setConfigJson("{\"uploadPath\":\"./uploads\",\"urlPrefix\":\"/uploads\"}");
        }
        return config;
    }

    public OssProperties propertiesOf(OssConfig config) {
        String json = cryptoUtil.decrypt(config.getConfigJson());
        if (json == null || json.isBlank()) {
            json = "{}";
        }
        return JSONUtil.toBean(json, OssProperties.class);
    }

    /** 当前生效的存储实现 */
    public OssStorage storage() {
        OssConfig config = currentConfig();
        return OssStorageFactory.create(config.getDriver(), propertiesOf(config));
    }

    /** 连接测试（可传临时配置，不落库） */
    public boolean test(OssConfig config) {
        if (config == null) {
            config = currentConfig();
        }
        try {
            OssStorage storage = OssStorageFactory.create(config.getDriver(), propertiesOf(config));
            boolean ok = storage.test();
            if (config.getId() != null) {
                OssConfig update = new OssConfig();
                update.setId(config.getId());
                update.setTestResult(ok ? "连接成功" : "连接失败");
                updateById(update);
            }
            return ok;
        } catch (Exception e) {
            if (config.getId() != null) {
                OssConfig update = new OssConfig();
                update.setId(config.getId());
                update.setTestResult("连接失败：" + e.getMessage());
                updateById(update);
            }
            return false;
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void saveConfig(OssConfig config) {
        if (config.getDriver() == null || !OssStorageFactory.DRIVERS.contains(config.getDriver().toUpperCase())) {
            throw new BizException("不支持的存储驱动");
        }
        // 敏感参数加密存储
        if (config.getConfigJson() != null && !config.getConfigJson().isBlank()) {
            config.setConfigJson(cryptoUtil.encrypt(config.getConfigJson()));
        }
        if (Integer.valueOf(1).equals(config.getIsDefault())) {
            OssConfig reset = new OssConfig();
            reset.setIsDefault(0);
            update(reset, new LambdaQueryWrapper<OssConfig>().eq(OssConfig::getIsDefault, 1));
        }
        saveOrUpdate(config);
    }

    /** 读取明文配置（供配置页回显） */
    public String plainConfigJson(Long id) {
        OssConfig config = getById(id);
        if (config == null) {
            throw new BizException("配置不存在");
        }
        return cryptoUtil.decrypt(config.getConfigJson());
    }
}
