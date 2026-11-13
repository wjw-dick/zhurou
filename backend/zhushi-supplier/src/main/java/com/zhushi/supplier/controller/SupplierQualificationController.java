package com.zhushi.supplier.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.supplier.entity.SupplierQualification;
import com.zhushi.supplier.service.SupplierQualificationService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 供应商资质 / 检疫证明（含审核）
 */
@Tag(name = "供应商资质")
@RestController
@RequestMapping("/supplier/qualification")
public class SupplierQualificationController extends BaseController<SupplierQualificationService, SupplierQualification> {

    private final SupplierQualificationService qualificationService;

    public SupplierQualificationController(SupplierQualificationService qualificationService,
                                           PermChecker permChecker) {
        super(permChecker);
        this.qualificationService = qualificationService;
    }

    @Override
    protected SupplierQualificationService service() {
        return qualificationService;
    }

    @Override
    protected String permPrefix() {
        return "supplier:qualification";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"qual_no"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SupplierQualification> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("supplierId")), "supplier_id", params.get("supplierId"))
                .eq(StrUtil.isNotBlank(params.get("qualType")), "qual_type", params.get("qualType"))
                .eq(StrUtil.isNotBlank(params.get("auditStatus")), "audit_status", params.get("auditStatus"))
                .orderByDesc("id");
    }

    /** 资质审核 */
    @OperationLog(module = "供应商资质", action = "资质审核")
    @RequiresPerm("supplier:qualification:audit")
    @PutMapping("/{id}/audit")
    public R<Void> audit(@PathVariable Long id,
                         @RequestParam String auditStatus,
                         @RequestParam(required = false) String auditRemark) {
        qualificationService.audit(id, auditStatus, auditRemark);
        return R.ok("审核完成", null);
    }
}
