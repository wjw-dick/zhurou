package com.zhushi.reserve.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.core.Constants;
import com.zhushi.common.exception.BizException;
import com.zhushi.reserve.dto.ReserveBookingDTO;
import com.zhushi.reserve.dto.ReserveStockSummary;
import com.zhushi.reserve.entity.ReserveStock;
import com.zhushi.reserve.mapper.ReserveStockMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * 鲜肉预订备货量：按日期+门店汇总，Redis 分布式锁 + 乐观锁防超卖
 */
@Service
@RequiredArgsConstructor
public class ReserveStockService extends ServiceImpl<ReserveStockMapper, ReserveStock> {

    /** 分布式锁持有时间（秒） */
    private static final Duration LOCK_TIMEOUT = Duration.ofSeconds(10);

    private final StringRedisTemplate stringRedisTemplate;

    /**
     * 按日期 + 门店汇总备货量：返回各商品规格的备货量、已预订量、剩余量
     */
    public List<ReserveStockSummary> summary(LocalDate reserveDate, Long storeId) {
        List<ReserveStock> stocks = list(new LambdaQueryWrapper<ReserveStock>()
                .eq(storeId != null, ReserveStock::getStoreId, storeId)
                .eq(reserveDate != null, ReserveStock::getReserveDate, reserveDate)
                .orderByAsc(ReserveStock::getStoreId)
                .orderByAsc(ReserveStock::getProductId));
        List<ReserveStockSummary> result = new ArrayList<>(stocks.size());
        for (ReserveStock stock : stocks) {
            int capacity = stock.getCapacity() == null ? 0 : stock.getCapacity();
            int booked = stock.getBooked() == null ? 0 : stock.getBooked();
            ReserveStockSummary item = new ReserveStockSummary();
            item.setId(stock.getId());
            item.setStoreId(stock.getStoreId());
            item.setProductId(stock.getProductId());
            item.setSkuId(stock.getSkuId());
            item.setReserveDate(stock.getReserveDate());
            item.setCapacity(capacity);
            item.setBooked(booked);
            item.setRemaining(Math.max(capacity - booked, 0));
            result.add(item);
        }
        return result;
    }

    /**
     * 预订扣减：Redis 分布式锁 + 乐观锁，防止并发超卖
     */
    @Transactional(rollbackFor = Exception.class)
    public void booking(ReserveBookingDTO dto) {
        if (dto == null || dto.getStoreId() == null || dto.getProductId() == null
                || dto.getReserveDate() == null || dto.getQuantity() == null || dto.getQuantity() <= 0) {
            throw new BizException("预订参数不完整");
        }
        String lockKey = Constants.RESERVE_LOCK_PREFIX + dto.getStoreId() + ":" + dto.getProductId()
                + ":" + dto.getReserveDate();
        Boolean locked = stringRedisTemplate.opsForValue().setIfAbsent(lockKey, "1", LOCK_TIMEOUT);
        if (locked == null || !locked) {
            throw new BizException("操作繁忙，请重试");
        }
        try {
            ReserveStock stock = getOne(new LambdaQueryWrapper<ReserveStock>()
                    .eq(ReserveStock::getStoreId, dto.getStoreId())
                    .eq(ReserveStock::getProductId, dto.getProductId())
                    .eq(ReserveStock::getReserveDate, dto.getReserveDate())
                    .eq(dto.getSkuId() != null, ReserveStock::getSkuId, dto.getSkuId()), false);
            if (stock == null) {
                throw new BizException("该日期暂未开放预订");
            }
            int capacity = stock.getCapacity() == null ? 0 : stock.getCapacity();
            int booked = stock.getBooked() == null ? 0 : stock.getBooked();
            if (booked + dto.getQuantity() > capacity) {
                throw new BizException("备货量不足，无法预订");
            }
            stock.setBooked(booked + dto.getQuantity());
            if (!updateById(stock)) {
                throw new BizException("预订失败，请重试");
            }
        } finally {
            stringRedisTemplate.delete(lockKey);
        }
    }
}
