package com.zhushi.staff.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.staff.entity.StaffTask;
import com.zhushi.staff.mapper.StaffTaskMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class StaffTaskService extends ServiceImpl<StaffTaskMapper, StaffTask> {

    /** 派单：写入负责店员，状态置为进行中 */
    public StaffTask assign(Long id, Long staffId) {
        StaffTask task = getById(id);
        if (task == null) {
            throw new BizException("待办任务不存在");
        }
        task.setStaffId(staffId);
        task.setStatus("DOING");
        updateById(task);
        return task;
    }

    /** 完成任务：状态置为 DONE，记录完成时间 */
    public StaffTask done(Long id) {
        StaffTask task = getById(id);
        if (task == null) {
            throw new BizException("待办任务不存在");
        }
        task.setStatus("DONE");
        task.setFinishTime(LocalDateTime.now());
        updateById(task);
        return task;
    }
}
