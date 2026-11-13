package com.zhushi.reserve.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.reserve.dto.ReserveBookingDTO;
import com.zhushi.reserve.dto.ReserveStockSummary;
import com.zhushi.reserve.entity.ReserveStock;
import com.zhushi.reserve.service.ReserveStockService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * 鲜肉预订备货量：汇总查询 + 预订扣减（Redis 锁防超卖）
 */
@Tag(name = "备货量")
@RestController
@RequestMapping("/reserve/stock")
public class ReserveStockController extends BaseController<ReserveStockService, ReserveStock> {

    private final ReserveStockService reserveStockService;

    public ReserveStockController(ReserveStockService reserveStockService, PermChecker permChecker) {
        super(permChecker);
        this.reserveStockService = reserveStockService;
    }

    @Override
    protected ReserveStockService service() {
        return reserveStockService;
    }

    @Override
    protected String permPrefix() {
        return "reserve:stock";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<ReserveStock> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("productId")), "product_id", params.get("productId"))
                .eq(StrUtil.isNotBlank(params.get("skuId")), "sku_id", params.get("skuId"))
                .eq(StrUtil.isNotBlank(params.get("reserveDate")), "reserve_date", params.get("reserveDate"))
                .orderByAsc("reserve_date")
                .orderByAsc("store_id");
    }

    /** 按日期 + 门店汇总备货量（备货量 / 已预订 / 剩余） */
    @RequiresPerm("reserve:stock:list")
    @GetMapping("/summary")
    public R<List<ReserveStockSummary>> summary(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate reserveDate,
            @RequestParam(required = false) Long storeId) {
        return R.ok(reserveStockService.summary(reserveDate, storeId));
    }

    /** 预订扣减：锁内校验备货量，防止超卖 */
    @OperationLog(module = "备货量", action = "预订扣减")
    @RequiresPerm("reserve:stock:edit")
    @PostMapping("/booking")
    public R<Void> booking(@RequestBody ReserveBookingDTO dto) {
        reserveStockService.booking(dto);
        return R.ok("预订成功", null);
    }
}
