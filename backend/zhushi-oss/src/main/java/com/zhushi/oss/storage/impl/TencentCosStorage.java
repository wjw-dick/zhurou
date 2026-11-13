package com.zhushi.oss.storage.impl;

import com.qcloud.cos.COSClient;
import com.qcloud.cos.ClientConfig;
import com.qcloud.cos.auth.BasicCOSCredentials;
import com.qcloud.cos.auth.COSCredentials;
import com.qcloud.cos.http.HttpProtocol;
import com.qcloud.cos.model.COSObject;
import com.qcloud.cos.model.ObjectMetadata;
import com.qcloud.cos.model.PutObjectRequest;
import com.qcloud.cos.region.Region;
import com.zhushi.oss.storage.OssProperties;
import com.zhushi.oss.storage.OssStorage;
import lombok.RequiredArgsConstructor;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

/**
 * 腾讯云 COS 存储驱动
 */
@RequiredArgsConstructor
public class TencentCosStorage implements OssStorage {

    private final OssProperties properties;

    private COSClient client() {
        COSCredentials cred = new BasicCOSCredentials(properties.getAccessKey(), properties.getSecretKey());
        ClientConfig config = new ClientConfig(new Region(properties.getRegion()));
        config.setHttpProtocol(HttpProtocol.https);
        return new COSClient(cred, config);
    }

    @Override
    public String driver() {
        return "COS";
    }

    @Override
    public String upload(byte[] bytes, String path, String contentType) {
        COSClient cos = client();
        try (ByteArrayInputStream in = new ByteArrayInputStream(bytes)) {
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(bytes.length);
            if (contentType != null) {
                metadata.setContentType(contentType);
            }
            cos.putObject(new PutObjectRequest(properties.getBucket(), path, in, metadata));
            return url(path);
        } catch (Exception e) {
            throw new com.zhushi.common.exception.BizException("腾讯云 COS 上传失败：" + e.getMessage());
        } finally {
            cos.shutdown();
        }
    }

    @Override
    public InputStream download(String path) {
        COSObject object = client().getObject(properties.getBucket(), path);
        return object.getObjectContent();
    }

    @Override
    public void delete(String path) {
        COSClient cos = client();
        try {
            cos.deleteObject(properties.getBucket(), path);
        } finally {
            cos.shutdown();
        }
    }

    @Override
    public boolean test() {
        COSClient cos = client();
        try {
            return cos.doesBucketExist(properties.getBucket());
        } catch (Exception e) {
            return false;
        } finally {
            cos.shutdown();
        }
    }

    @Override
    public String url(String path) {
        return properties.joinUrl(path);
    }
}
