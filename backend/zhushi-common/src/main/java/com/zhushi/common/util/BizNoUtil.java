package com.zhushi.common.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 业务单号生成：前缀 + yyyyMMdd + 6 位随机/自增
 */
public class BizNoUtil {

    private static final DateTimeFormatter DF = DateTimeFormatter.ofPattern("yyyyMMdd");
    private static final AtomicInteger SEQ = new AtomicInteger(0);

    public static String next(String prefix) {
        int seq = Math.floorMod(SEQ.incrementAndGet(), 10000);
        return prefix + LocalDate.now().format(DF)
                + String.format("%04d", seq)
                + ThreadLocalRandom.current().nextInt(10, 99);
    }
}
