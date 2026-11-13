package com.zhushi.staff.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.zhushi.common.core.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 店员备货/配货待办
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("staff_task")
public class StaffTask extends BaseEntity {

    private Long storeId;
    private Long staffId;
    private Long orderId;
    private String orderNo;
    private String taskType;
    private LocalDate taskDate;
    private String content;
    private String status;
    private LocalDateTime finishTime;
}
