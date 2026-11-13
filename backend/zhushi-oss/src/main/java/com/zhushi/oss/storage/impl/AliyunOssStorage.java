package com.zhushi.oss.storage.impl;

import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.model.OSSObject;
import com.zhushi.oss.storage.OssProperties;
import com.zhushi.oss.storage.OssStorage;
import lombok.RequiredArgsConstructor;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

/**
 * 阿里云 OSS 存储驱动
 */
@RequiredArgsConstructor
public class AliyunOssStorage implements OssStorage {

    private final OssProperties properties;

    private OSS client() {
        return new OSSClientBuilder()
                .build(properties.getEndpoint(), properties.getAccessKey(), properties.getSecretKey());
    }

    @Override
    public String driver() {
        return "OSS";
    }

    @Override
    public String upload(byte[] bytes, String path, String contentType) {
        OSS oss = client();
        try (ByteArrayInputStream in = new ByteArrayInputStream(bytes)) {
            oss.putObject(properties.getBucket(), path, in);
            return url(path);
        } catch (Exception e) {
            throw new com.zhushi.common.exception.BizException("阿里云 OSS 上传失败：" + e.getMessage());
        } finally {
            oss.shutdown();
        }
    }

    @Override
    public InputStream download(String path) {
        OSSObject object = client().getObject(properties.getBucket(), path);
        return object.getObjectContent();
    }

    @Override
    public void delete(String path) {
        OSS oss = client();
        try {
            oss.deleteObject(properties.getBucket(), path);
        } finally {
            oss.shutdown();
        }
    }

    @Override
    public boolean test() {
        OSS oss = client();
        try {
            return oss.doesBucketExist(properties.getBucket());
        } catch (Exception e) {
            return false;
        } finally {
            oss.shutdown();
        }
    }

    @Override
    public String url(String path) {
        return properties.joinUrl(path);
    }
}
