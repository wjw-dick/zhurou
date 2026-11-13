package com.zhushi.oss.storage.impl;

import com.zhushi.oss.storage.OssProperties;
import com.zhushi.oss.storage.OssStorage;
import lombok.RequiredArgsConstructor;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.InputStream;
import java.net.URI;

/**
 * S3 存储驱动（AWS S3 及兼容服务）
 */
@RequiredArgsConstructor
public class S3OssStorage implements OssStorage {

    private final OssProperties properties;

    private S3Client client() {
        return S3Client.builder()
                .endpointOverride(URI.create(properties.getEndpoint()))
                .region(Region.of(properties.getRegion()))
                .credentialsProvider(StaticCredentialsProvider.create(
                        AwsBasicCredentials.create(properties.getAccessKey(), properties.getSecretKey())))
                .forcePathStyle(true)
                .build();
    }

    @Override
    public String driver() {
        return "S3";
    }

    @Override
    public String upload(byte[] bytes, String path, String contentType) {
        try {
            client().putObject(PutObjectRequest.builder()
                    .bucket(properties.getBucket())
                    .key(path)
                    .contentType(contentType == null ? "application/octet-stream" : contentType)
                    .build(), RequestBody.fromBytes(bytes));
            return url(path);
        } catch (Exception e) {
            throw new com.zhushi.common.exception.BizException("S3 上传失败：" + e.getMessage());
        }
    }

    @Override
    public InputStream download(String path) {
        try {
            return client().getObject(GetObjectRequest.builder()
                    .bucket(properties.getBucket()).key(path).build());
        } catch (Exception e) {
            throw new com.zhushi.common.exception.BizException("S3 下载失败：" + e.getMessage());
        }
    }

    @Override
    public void delete(String path) {
        try {
            client().deleteObject(b -> b.bucket(properties.getBucket()).key(path));
        } catch (Exception e) {
            throw new com.zhushi.common.exception.BizException("S3 删除失败：" + e.getMessage());
        }
    }

    @Override
    public boolean test() {
        try {
            client().headBucket(b -> b.bucket(properties.getBucket()));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public String url(String path) {
        return properties.joinUrl(path);
    }
}
