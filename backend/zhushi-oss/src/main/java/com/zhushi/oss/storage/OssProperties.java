package com.zhushi.oss.storage;

import lombok.Data;

/**
 * 对象存储参数（对应 oss_config.config_json）
 */
@Data
public class OssProperties {

    /** LOCAL 上传根目录 */
    private String uploadPath = "./uploads";
    /** 访问域名前缀 */
    private String urlPrefix = "/uploads";
    /** 服务端点，如 oss-cn-hangzhou.aliyuncs.com / minio.xxx.com:9000 */
    private String endpoint;
    private String region = "us-east-1";
    private String bucket;
    private String accessKey;
    private String secretKey;

    public String joinUrl(String path) {
        String base = urlPrefix == null ? "" : urlPrefix;
        if (!base.isEmpty() && !base.endsWith("/")) {
            base = base + "/";
        }
        return base + path;
    }
}
