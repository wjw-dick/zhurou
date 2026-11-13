package com.zhushi.oss.storage.impl;

import com.zhushi.oss.storage.OssProperties;
import com.zhushi.oss.storage.OssStorage;
import io.minio.BucketExistsArgs;
import io.minio.GetObjectArgs;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.RemoveObjectArgs;
import lombok.RequiredArgsConstructor;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

/**
 * MinIO 存储驱动
 */
@RequiredArgsConstructor
public class MinioOssStorage implements OssStorage {

    private final OssProperties properties;

    private MinioClient client() {
        return MinioClient.builder()
                .endpoint(properties.getEndpoint())
                .credentials(properties.getAccessKey(), properties.getSecretKey())
                .build();
    }

    @Override
    public String driver() {
        return "MINIO";
    }

    @Override
    public String upload(byte[] bytes, String path, String contentType) {
        try (ByteArrayInputStream in = new ByteArrayInputStream(bytes)) {
            client().putObject(PutObjectArgs.builder()
                    .bucket(properties.getBucket())
                    .object(path)
                    .stream(in, bytes.length, -1)
                    .contentType(contentType == null ? "application/octet-stream" : contentType)
                    .build());
            return url(path);
        } catch (Exception e) {
            throw new com.zhushi.common.exception.BizException("MinIO 上传失败：" + e.getMessage());
        }
    }

    @Override
    public InputStream download(String path) {
        try {
            return client().getObject(GetObjectArgs.builder()
                    .bucket(properties.getBucket()).object(path).build());
        } catch (Exception e) {
            throw new com.zhushi.common.exception.BizException("MinIO 下载失败：" + e.getMessage());
        }
    }

    @Override
    public void delete(String path) {
        try {
            client().removeObject(RemoveObjectArgs.builder()
                    .bucket(properties.getBucket()).object(path).build());
        } catch (Exception e) {
            throw new com.zhushi.common.exception.BizException("MinIO 删除失败：" + e.getMessage());
        }
    }

    @Override
    public boolean test() {
        try {
            return client().bucketExists(BucketExistsArgs.builder()
                    .bucket(properties.getBucket()).build());
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public String url(String path) {
        return properties.joinUrl(path);
    }
}
