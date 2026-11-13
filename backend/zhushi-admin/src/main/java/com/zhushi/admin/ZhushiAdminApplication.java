package com.zhushi.admin;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 猪事大吉 · 多端数字化平台 启动入口
 */
@SpringBootApplication(scanBasePackages = "com.zhushi")
@MapperScan("com.zhushi.**.mapper")
public class ZhushiAdminApplication {

    public static void main(String[] args) {
        SpringApplication.run(ZhushiAdminApplication.class, args);
    }
}
