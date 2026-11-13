package com.zhushi.oss.storage;

import com.zhushi.common.exception.BizException;
import com.zhushi.oss.storage.impl.AliyunOssStorage;
import com.zhushi.oss.storage.impl.LocalOssStorage;
import com.zhushi.oss.storage.impl.MinioOssStorage;
import com.zhushi.oss.storage.impl.S3OssStorage;
import com.zhushi.oss.storage.impl.TencentCosStorage;

import java.util.List;

/**
 * 对象存储驱动工厂：5 驱动可切
 */
public class OssStorageFactory {

    public static final List<String> DRIVERS = List.of("LOCAL", "MINIO", "S3", "OSS", "COS");

    public static OssStorage create(String driver, OssProperties properties) {
        if (driver == null) {
            driver = "LOCAL";
        }
        return switch (driver.toUpperCase()) {
            case "LOCAL" -> new LocalOssStorage(properties);
            case "MINIO" -> new MinioOssStorage(properties);
            case "S3" -> new S3OssStorage(properties);
            case "OSS" -> new AliyunOssStorage(properties);
            case "COS" -> new TencentCosStorage(properties);
            default -> throw new BizException("不支持的对象存储驱动：" + driver);
        };
    }
}
