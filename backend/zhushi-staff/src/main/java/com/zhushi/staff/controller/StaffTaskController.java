package com.zhushi.staff.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.staff.entity.StaffTask;
import com.zhushi.staff.service.StaffTaskService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 店员备货/配货待办
 */
@Tag(name = "店员待办")
@RestController
@RequestMapping("/staff/task")
public class StaffTaskController extends BaseController<StaffTaskService, StaffTask> {

    private final StaffTaskService staffTaskService;

    public StaffTaskController(StaffTaskService staffTaskService, PermChecker permChecker) {
        super(permChecker);
        this.staffTaskService = staffTaskService;
    }

    @Override
    protected StaffTaskService service() {
        return staffTaskService;
    }

    @Override
    protected String permPrefix() {
        return "staff:task";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"order_no", "content"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<StaffTask> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("storeId")), "store_id", params.get("storeId"))
                .eq(StrUtil.isNotBlank(params.get("staffId")), "staff_id", params.get("staffId"))
                .eq(StrUtil.isNotBlank(params.get("taskType")), "task_type", params.get("taskType"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .eq(StrUtil.isNotBlank(params.get("taskDate")), "task_date", params.get("taskDate"))
                .orderByDesc("id");
    }

    /** 派单 */
    @OperationLog(module = "店员待办", action = "派单")
    @RequiresPerm("staff:task:assign")
    @PutMapping("/{id}/assign")
    public R<StaffTask> assign(@PathVariable Long id, @RequestParam Long staffId) {
        return R.ok(staffTaskService.assign(id, staffId));
    }

    /** 完成待办 */
    @OperationLog(module = "店员待办", action = "完成任务")
    @RequiresPerm("staff:task:assign")
    @PutMapping("/{id}/done")
    public R<StaffTask> done(@PathVariable Long id) {
        return R.ok(staffTaskService.done(id));
    }
}
