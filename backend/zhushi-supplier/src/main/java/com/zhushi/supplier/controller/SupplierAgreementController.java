package com.zhushi.supplier.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.security.PermChecker;
import com.zhushi.supplier.entity.SupplierAgreement;
import com.zhushi.supplier.service.SupplierAgreementService;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * 供货协议管理
 */
@Tag(name = "供货协议")
@RestController
@RequestMapping("/supplier/agreement")
public class SupplierAgreementController extends BaseController<SupplierAgreementService, SupplierAgreement> {

    private final SupplierAgreementService agreementService;

    public SupplierAgreementController(SupplierAgreementService agreementService, PermChecker permChecker) {
        super(permChecker);
        this.agreementService = agreementService;
    }

    @Override
    protected SupplierAgreementService service() {
        return agreementService;
    }

    @Override
    protected String permPrefix() {
        return "supplier:agreement";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"title", "agreement_no"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, QueryWrapper<SupplierAgreement> wrapper) {
        wrapper.eq(StrUtil.isNotBlank(params.get("supplierId")), "supplier_id", params.get("supplierId"))
                .eq(StrUtil.isNotBlank(params.get("status")), "status", params.get("status"))
                .orderByDesc("id");
    }
}
