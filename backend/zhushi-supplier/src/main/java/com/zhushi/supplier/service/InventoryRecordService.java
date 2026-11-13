package com.zhushi.supplier.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.supplier.entity.InventoryRecord;
import com.zhushi.supplier.mapper.InventoryRecordMapper;
import org.springframework.stereotype.Service;

/**
 * 出入库 / 损耗记录服务
 */
@Service
public class InventoryRecordService extends ServiceImpl<InventoryRecordMapper, InventoryRecord> {

    /** 新增出入库记录，缺省记录类型为入库 */
    public void saveRecord(InventoryRecord record) {
        if (record.getRecordType() == null || record.getRecordType().isBlank()) {
            record.setRecordType("IN");
        }
        save(record);
    }

    /** 校验记录存在性后删除（软删除） */
    public void removeRecord(Long id) {
        if (getById(id) == null) {
            throw new BizException("出入库记录不存在");
        }
        removeById(id);
    }
}
