package com.zhushi.common.util;

import cn.hutool.crypto.SecureUtil;
import cn.hutool.crypto.symmetric.AES;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;

/**
 * 敏感配置加解密（AES）：用于存储类 AK/SK、微信密钥等
 */
@Component
public class CryptoUtil {

    @Value("${zhushi.crypto.key:zhushidaji-2026-secret-key-16}")
    private String key;

    private AES aes() {
        String k = key.length() > 32 ? key.substring(0, 32) : key;
        return SecureUtil.aes(k.getBytes(StandardCharsets.UTF_8));
    }

    public String encrypt(String text) {
        if (text == null || text.isEmpty()) {
            return text;
        }
        return aes().encryptBase64(text);
    }

    public String decrypt(String cipher) {
        if (cipher == null || cipher.isEmpty()) {
            return cipher;
        }
        try {
            return aes().decryptStr(cipher);
        } catch (Exception e) {
            return cipher;
        }
    }

    /** 掩码显示，如 AKIS****1234 */
    public String mask(String text) {
        if (text == null || text.isEmpty()) {
            return text;
        }
        if (text.length() <= 8) {
            return "****";
        }
        return text.substring(0, 4) + "****" + text.substring(text.length() - 4);
    }
}
