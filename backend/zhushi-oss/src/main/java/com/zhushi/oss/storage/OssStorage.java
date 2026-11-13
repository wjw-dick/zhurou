package com.zhushi.oss.storage;

import java.io.InputStream;

/**
 * 对象存储抽象接口：本地 / S3 / OSS / COS / MinIO 五驱动可切
 */
public interface OssStorage {

    /** 驱动标识 */
    String driver();

    /** 上传，返回可访问 URL */
    String upload(byte[] bytes, String path, String contentType);

    /** 下载 */
    InputStream download(String path);

    /** 删除 */
    void delete(String path);

    /** 连接测试 */
    boolean test();

    /** 访问地址 */
    String url(String path);
}
