package com.zhushi.supplier.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.supplier.entity.InventoryWarning;
import com.zhushi.supplier.mapper.InventoryWarningMapper;
import org.springframework.stereotype.Service;

/**
 * 库存预警服务
 */
@Service
public class InventoryWarningService extends ServiceImpl<InventoryWarningMapper, InventoryWarning> {

    /** 处理预警：PENDING → HANDLED */
    public void handle(Long id) {
        InventoryWarning warning = getById(id);
        if (warning == null) {
            throw new BizException("预警记录不存在");
        }
        InventoryWarning update = new InventoryWarning();
        update.setId(id);
        update.setStatus("HANDLED");
        updateById(update);
    }
}
