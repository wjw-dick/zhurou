package com.zhushi.supplier.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.supplier.entity.PurchasePlan;
import com.zhushi.supplier.mapper.PurchasePlanMapper;
import org.springframework.stereotype.Service;

/**
 * 采购计划服务
 */
@Service
public class PurchasePlanService extends ServiceImpl<PurchasePlanMapper, PurchasePlan> {

    /** 提交采购计划：DRAFT → SUBMITTED */
    public void submit(Long id) {
        PurchasePlan plan = getById(id);
        if (plan == null) {
            throw new BizException("采购计划不存在");
        }
        PurchasePlan update = new PurchasePlan();
        update.setId(id);
        update.setStatus("SUBMITTED");
        updateById(update);
    }
}
