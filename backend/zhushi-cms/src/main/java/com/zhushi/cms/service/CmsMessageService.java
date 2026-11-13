package com.zhushi.cms.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.cms.entity.CmsMessage;
import com.zhushi.cms.mapper.CmsMessageMapper;
import com.zhushi.common.exception.BizException;
import org.springframework.stereotype.Service;

/**
 * 留言 / 团购咨询服务
 */
@Service
public class CmsMessageService extends ServiceImpl<CmsMessageMapper, CmsMessage> {

    /** 处理留言：更新状态并记录备注 */
    public void handle(Long id, String status, String remark) {
        CmsMessage message = getById(id);
        if (message == null) {
            throw new BizException("留言不存在");
        }
        CmsMessage update = new CmsMessage();
        update.setId(id);
        update.setStatus(status);
        update.setRemark(remark);
        updateById(update);
    }
}
