package com.zhushi.oss.storage.impl;

import com.zhushi.oss.storage.OssProperties;
import com.zhushi.oss.storage.OssStorage;
import lombok.RequiredArgsConstructor;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * 本地存储驱动
 */
@RequiredArgsConstructor
public class LocalOssStorage implements OssStorage {

    private final OssProperties properties;

    private Path root() {
        return Paths.get(properties.getUploadPath()).toAbsolutePath().normalize();
    }

    @Override
    public String driver() {
        return "LOCAL";
    }

    @Override
    public String upload(byte[] bytes, String path, String contentType) {
        try {
            Path target = root().resolve(path).normalize();
            Files.createDirectories(target.getParent());
            Files.write(target, bytes);
            return url(path);
        } catch (IOException e) {
            throw new com.zhushi.common.exception.BizException("本地文件保存失败：" + e.getMessage());
        }
    }

    @Override
    public InputStream download(String path) {
        try {
            return Files.newInputStream(root().resolve(path).normalize());
        } catch (IOException e) {
            throw new com.zhushi.common.exception.BizException("文件不存在：" + path);
        }
    }

    @Override
    public void delete(String path) {
        try {
            Files.deleteIfExists(root().resolve(path).normalize());
        } catch (IOException e) {
            throw new com.zhushi.common.exception.BizException("文件删除失败：" + e.getMessage());
        }
    }

    @Override
    public boolean test() {
        try {
            Files.createDirectories(root());
            return Files.isWritable(root());
        } catch (IOException e) {
            return false;
        }
    }

    @Override
    public String url(String path) {
        return properties.joinUrl(path);
    }
}
