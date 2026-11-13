package com.zhushi.channel.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.channel.entity.Channel;
import com.zhushi.channel.entity.ChannelCommissionRule;
import com.zhushi.channel.entity.ChannelOrder;
import com.zhushi.channel.mapper.ChannelMapper;
import com.zhushi.channel.mapper.ChannelCommissionRuleMapper;
import com.zhushi.channel.mapper.ChannelOrderMapper;
import com.zhushi.common.exception.BizException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * 渠道报单服务：审核通过时按规则计算佣金
 */
@Service
@RequiredArgsConstructor
public class ChannelOrderService extends ServiceImpl<ChannelOrderMapper, ChannelOrder> {

    private final ChannelMapper channelMapper;
    private final ChannelCommissionRuleMapper ruleMapper;

    /**
     * 报单审核。status 取 APPROVED / REJECTED。
     * 通过时按「渠道+商品 > 渠道+品类 > 渠道 > 全局」优先级匹配佣金规则并回写佣金。
     */
    @Transactional(rollbackFor = Exception.class)
    public void audit(Long id, String status, String auditRemark) {
        ChannelOrder order = getById(id);
        if (order == null) {
            throw new BizException("报单不存在");
        }
        if (!"APPROVED".equalsIgnoreCase(status) && !"REJECTED".equalsIgnoreCase(status)) {
            throw new BizException("审核状态不合法");
        }
        ChannelOrder update = new ChannelOrder();
        update.setId(id);
        update.setStatus(status.toUpperCase());
        update.setAuditRemark(auditRemark);
        if ("APPROVED".equalsIgnoreCase(status)) {
            ChannelCommissionRule rule = matchRule(order);
            BigDecimal commission = calculate(order, rule);
            update.setCommission(commission);
            if (rule != null) {
                update.setCommissionRuleId(rule.getId());
            }
        }
        updateById(update);
    }

    /** 按优先级匹配规则 */
    private ChannelCommissionRule matchRule(ChannelOrder order) {
        List<ChannelCommissionRule> rules = ruleMapper.selectList(new LambdaQueryWrapper<ChannelCommissionRule>()
                .eq(ChannelCommissionRule::getStatus, 1));
        // 1) 渠道 + 指定商品
        for (ChannelCommissionRule r : rules) {
            if (order.getChannelId().equals(r.getChannelId()) && r.getProductId() != null) {
                return r;
            }
        }
        // 2) 渠道级（不限商品/品类）
        for (ChannelCommissionRule r : rules) {
            if (order.getChannelId().equals(r.getChannelId()) && r.getBizType() == null && r.getProductId() == null) {
                return r;
            }
        }
        // 3) 全局规则（层级 1）
        for (ChannelCommissionRule r : rules) {
            if (r.getChannelId() == null && (r.getLevel() == null || r.getLevel() == 1)) {
                return r;
            }
        }
        return null;
    }

    private BigDecimal calculate(ChannelOrder order, ChannelCommissionRule rule) {
        BigDecimal amount = order.getAmount() == null ? BigDecimal.ZERO : order.getAmount();
        if (rule != null) {
            if ("FIXED".equalsIgnoreCase(rule.getRuleType())) {
                return rule.getFixedAmount() == null ? BigDecimal.ZERO : rule.getFixedAmount();
            }
            BigDecimal rate = rule.getRate() == null ? BigDecimal.ZERO : rule.getRate();
            return amount.multiply(rate).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        }
        // 兜底：渠道默认佣金比例
        Channel channel = channelMapper.selectById(order.getChannelId());
        BigDecimal rate = channel == null || channel.getCommissionRate() == null
                ? BigDecimal.ZERO : channel.getCommissionRate();
        return amount.multiply(rate).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
    }
}
