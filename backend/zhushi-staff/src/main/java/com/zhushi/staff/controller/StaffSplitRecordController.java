package com.zhushi.staff.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.staff.entity.StaffSplitRecord;
import com.zhushi.staff.service.StaffSplitRecordService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 分割加工登记
 */
@Tag(name = "分割加工登记")
@RestController
@RequestMapping("/staff/split")
public class StaffSplitRecordController extends BaseController<StaffSplitRecordService, StaffSplitRecord> {

    private final StaffSplitRecordService staffSplitRecordService;

    public StaffSplitRecordController(StaffSplitRecordService staffSplitRecordService, PermChecker permChecker) {
        super(permChecker);
        this.staffSplitRecordService = staffSplitRecordService;
    }

    @Override
    protected StaffSplitRecordService service() {
        return staffSplitRecordService;
    }

    @Override
    protected String permPrefix() {
        return "staff:split";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"product_name", "order_no"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<StaffSplitRecord> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("staffId")), "staff_id", params.get("staffId"))
                .eq(StrUtil.isNotBlank(params.get("splitType")), "split_type", params.get("splitType"))
                .orderByDesc("id");
    }

    /** 登记分割加工（并累计当天业绩） */
    @OperationLog(module = "分割加工登记", action = "登记")
    @RequiresPerm("staff:split:add")
    @PostMapping("/register")
    public R<Long> register(@RequestBody StaffSplitRecord record) {
        staffSplitRecordService.register(record);
        return R.ok(record.getId());
    }
}
