package com.zhushi.staff.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.staff.entity.Staff;
import com.zhushi.staff.service.StaffService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 店员档案管理
 */
@Tag(name = "店员档案")
@RestController
@RequestMapping("/staff/info")
public class StaffController extends BaseController<StaffService, Staff> {

    private final StaffService staffService;

    public StaffController(StaffService staffService, PermChecker permChecker) {
        super(permChecker);
        this.staffService = staffService;
    }

    @Override
    protected StaffService service() {
        return staffService;
    }

    @Override
    protected String permPrefix() {
        return "staff:info";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"name", "phone"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<Staff> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("staffType")), "staff_type", params.get("staffType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }
}
