package com.zhushi.staff.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.staff.entity.StaffPerformance;
import com.zhushi.staff.service.StaffPerformanceService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Map;

/**
 * 店员业绩/提成
 */
@Tag(name = "店员业绩")
@RestController
@RequestMapping("/staff/performance")
public class StaffPerformanceController extends BaseController<StaffPerformanceService, StaffPerformance> {

    private final StaffPerformanceService staffPerformanceService;

    public StaffPerformanceController(StaffPerformanceService staffPerformanceService, PermChecker permChecker) {
        super(permChecker);
        this.staffPerformanceService = staffPerformanceService;
    }

    @Override
    protected StaffPerformanceService service() {
        return staffPerformanceService;
    }

    @Override
    protected String permPrefix() {
        return "staff:performance";
    }

    @Override
    protected String[] searchFields() {
        return new String[0];
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<StaffPerformance> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("staffId")), "staff_id", params.get("staffId"))
                .eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .ge(StrUtil.isNotBlank(params.get("startDate")), "stat_date", params.get("startDate"))
                .le(StrUtil.isNotBlank(params.get("endDate")), "stat_date", params.get("endDate"))
                .orderByDesc("stat_date");
    }

    /** 区间业绩汇总 */
    @OperationLog(module = "店员业绩", action = "汇总")
    @RequiresPerm("staff:performance:list")
    @GetMapping("/summary")
    public R<Map<String, Object>> summary(@RequestParam(required = false) Long staffId,
                                          @RequestParam(required = false) String startDate,
                                          @RequestParam(required = false) String endDate) {
        return R.ok(staffPerformanceService.summary(staffId, parseDate(startDate), parseDate(endDate)));
    }

    private LocalDate parseDate(String value) {
        if (StrUtil.isBlank(value)) {
            return null;
        }
        try {
            return LocalDate.parse(value);
        } catch (DateTimeParseException e) {
            return null;
        }
    }
}
