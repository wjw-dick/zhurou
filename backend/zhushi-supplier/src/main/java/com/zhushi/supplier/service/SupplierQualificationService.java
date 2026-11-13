package com.zhushi.supplier.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.supplier.entity.SupplierQualification;
import com.zhushi.supplier.mapper.SupplierQualificationMapper;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 供应商资质 / 检疫证明服务
 */
@Service
public class SupplierQualificationService extends ServiceImpl<SupplierQualificationMapper, SupplierQualification> {

    /** 某供应商的资质列表 */
    public List<SupplierQualification> listBySupplier(Long supplierId) {
        return list(new LambdaQueryWrapper<SupplierQualification>()
                .eq(SupplierQualification::getSupplierId, supplierId)
                .orderByDesc(SupplierQualification::getId));
    }

    /** 资质审核：PENDING 待审核 / APPROVED 已通过 / REJECTED 已驳回 */
    public void audit(Long id, String auditStatus, String auditRemark) {
        SupplierQualification qualification = getById(id);
        if (qualification == null) {
            throw new BizException("资质记录不存在");
        }
        if (!"APPROVED".equals(auditStatus) && !"REJECTED".equals(auditStatus)) {
            throw new BizException("审核状态不合法");
        }
        SupplierQualification update = new SupplierQualification();
        update.setId(id);
        update.setAuditStatus(auditStatus);
        update.setAuditRemark(auditRemark);
        updateById(update);
    }
}
