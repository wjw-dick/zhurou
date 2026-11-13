package com.zhushi.portal.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zhushi.cms.entity.CmsArticle;
import com.zhushi.cms.entity.CmsBanner;
import com.zhushi.cms.entity.CmsCategory;
import com.zhushi.cms.entity.CmsMessage;
import com.zhushi.cms.service.CmsArticleService;
import com.zhushi.cms.service.CmsBannerService;
import com.zhushi.cms.service.CmsCategoryService;
import com.zhushi.cms.service.CmsMessageService;
import com.zhushi.common.core.PageResult;
import com.zhushi.common.exception.BizException;
import com.zhushi.common.util.BizNoUtil;
import com.zhushi.member.entity.Coupon;
import com.zhushi.member.entity.Member;
import com.zhushi.member.service.CouponService;
import com.zhushi.member.service.MemberService;
import com.zhushi.order.entity.OrderInfo;
import com.zhushi.order.entity.OrderItem;
import com.zhushi.order.entity.OrderLog;
import com.zhushi.order.service.OrderInfoService;
import com.zhushi.order.service.OrderItemService;
import com.zhushi.order.service.OrderLogService;
import com.zhushi.portal.dto.PortalLoginDTO;
import com.zhushi.portal.dto.PortalOrderDTO;
import com.zhushi.product.entity.Product;
import com.zhushi.product.entity.ProductCategory;
import com.zhushi.product.entity.ProductQualification;
import com.zhushi.product.entity.ProductSku;
import com.zhushi.product.service.ProductCategoryService;
import com.zhushi.product.service.ProductService;
import com.zhushi.reserve.entity.ReserveConfig;
import com.zhushi.reserve.service.ReserveConfigService;
import com.zhushi.store.entity.Store;
import com.zhushi.store.service.StoreService;
import com.zhushi.system.entity.SysConfig;
import com.zhushi.system.service.SysConfigService;
import com.zhushi.system.service.SysMenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 对外门户服务：官网 / 小程序 / H5 共用
 */
@Service
@RequiredArgsConstructor
public class PortalService {

    private final ProductService productService;
    private final ProductCategoryService categoryService;
    private final StoreService storeService;
    private final CmsBannerService bannerService;
    private final CmsArticleService articleService;
    private final CmsCategoryService cmsCategoryService;
    private final CmsMessageService messageService;
    private final MemberService memberService;
    private final CouponService couponService;
    private final OrderInfoService orderInfoService;
    private final OrderItemService orderItemService;
    private final OrderLogService orderLogService;
    private final ReserveConfigService reserveConfigService;
    private final SysConfigService sysConfigService;
    private final SysMenuService sysMenuService;

    /** 站点公开配置（不返回加密项） */
    public Map<String, String> siteConfig() {
        Map<String, String> kv = new LinkedHashMap<>();
        List<SysConfig> list = sysConfigService.list(new LambdaQueryWrapper<SysConfig>()
                .eq(SysConfig::getGroupCode, "site")
                .orderByAsc(SysConfig::getSort));
        for (SysConfig config : list) {
            kv.put(config.getConfigKey(), config.getConfigValue());
        }
        return kv;
    }

    /** 导航菜单（PC / WECHAT / MINIAPP / H5） */
    public Object navMenus(String platform) {
        return sysMenuService.listByPlatform(platform, true).stream()
                .filter(m -> !"BUTTON".equals(m.getMenuType()))
                .collect(Collectors.toList());
    }

    public List<CmsBanner> banners(String position) {
        return bannerService.list(new LambdaQueryWrapper<CmsBanner>()
                .eq(CmsBanner::getStatus, 1)
                .eq(position != null && !position.isBlank(), CmsBanner::getPosition, position)
                .orderByAsc(CmsBanner::getSort));
    }

    public List<ProductCategory> categories(String bizType) {
        return categoryService.listByBizType(bizType);
    }

    public List<ProductCategory> categoryTree(String bizType) {
        return com.zhushi.common.util.TreeUtil.build(categoryService.listByBizType(bizType));
    }

    public PageResult<Product> products(Long categoryId, String bizType, String keyword,
                                        Integer reservable, long current, long size) {
        Page<Product> page = productService.page(new Page<>(current, Math.min(size, 100)),
                new LambdaQueryWrapper<Product>()
                        .eq(Product::getStatus, 1)
                        .eq(categoryId != null, Product::getCategoryId, categoryId)
                        .eq(bizType != null && !bizType.isBlank(), Product::getBizType, bizType)
                        .eq(reservable != null, Product::getReservable, reservable)
                        .and(keyword != null && !keyword.isBlank(),
                                w -> w.like(Product::getName, keyword).or().like(Product::getSubTitle, keyword))
                        .orderByAsc(Product::getSort)
                        .orderByDesc(Product::getSales));
        return PageResult.of(page);
    }

    /** 商品详情：含规格、检疫证、可售门店 */
    public Map<String, Object> productDetail(Long id) {
        Product product = productService.getById(id);
        if (product == null || product.getStatus() == null || product.getStatus() != 1) {
            throw new BizException("商品不存在或已下架");
        }
        Map<String, Object> result = new HashMap<>();
        result.put("product", product);
        result.put("skus", productService.skus(id));
        List<ProductQualification> quals = productService.qualifications(id).stream()
                .filter(q -> Integer.valueOf(1).equals(q.getStatus()))
                .collect(Collectors.toList());
        result.put("qualifications", quals);
        return result;
    }

    public List<Store> stores() {
        return storeService.listEnabled();
    }

    public Store store(Long id) {
        return storeService.getById(id);
    }

    /** 门店预订配置 */
    public ReserveConfig reserveConfig(Long storeId) {
        return reserveConfigService.getOne(new LambdaQueryWrapper<ReserveConfig>()
                .eq(storeId != null, ReserveConfig::getStoreId, storeId)
                .eq(ReserveConfig::getStatus, 1), false);
    }

    public PageResult<CmsArticle> articles(Long categoryId, String articleType, long current, long size) {
        Page<CmsArticle> page = articleService.page(new Page<>(current, Math.min(size, 50)),
                new LambdaQueryWrapper<CmsArticle>()
                        .eq(CmsArticle::getStatus, 1)
                        .eq(categoryId != null, CmsArticle::getCategoryId, categoryId)
                        .eq(articleType != null && !articleType.isBlank(), CmsArticle::getArticleType, articleType)
                        .orderByDesc(CmsArticle::getIsTop)
                        .orderByDesc(CmsArticle::getPublishTime)
                        .orderByDesc(CmsArticle::getId));
        return PageResult.of(page);
    }

    public CmsArticle article(Long id) {
        CmsArticle article = articleService.getById(id);
        if (article == null || !Integer.valueOf(1).equals(article.getStatus())) {
            throw new BizException("文章不存在");
        }
        // 浏览量 +1（忽略失败）
        try {
            CmsArticle update = new CmsArticle();
            update.setId(id);
            update.setViews((article.getViews() == null ? 0 : article.getViews()) + 1);
            articleService.updateById(update);
        } catch (Exception ignored) {
            // ignore
        }
        return article;
    }

    public List<CmsCategory> cmsCategories() {
        return cmsCategoryService.list(new LambdaQueryWrapper<CmsCategory>()
                .eq(CmsCategory::getStatus, 1)
                .orderByAsc(CmsCategory::getSort));
    }

    /** 提交留言 / 团购咨询 */
    public void submitMessage(CmsMessage message) {
        if (message == null || message.getContent() == null || message.getContent().isBlank()) {
            throw new BizException("请填写留言内容");
        }
        if (message.getMsgType() == null || message.getMsgType().isBlank()) {
            message.setMsgType("CONTACT");
        }
        if (message.getStatus() == null) {
            message.setStatus("UNREAD");
        }
        message.setId(null);
        messageService.save(message);
    }

    /** 可用优惠券 */
    public List<Coupon> coupons() {
        return couponService.list(new LambdaQueryWrapper<Coupon>()
                .eq(Coupon::getStatus, 1)
                .orderByAsc(Coupon::getId));
    }

    /** 微信登录：openid 不存在则自动注册会员 */
    @Transactional(rollbackFor = Exception.class)
    public Member login(PortalLoginDTO dto) {
        if (dto == null || dto.getOpenid() == null || dto.getOpenid().isBlank()) {
            throw new BizException("缺少 openid");
        }
        Member member = memberService.getOne(new LambdaQueryWrapper<Member>()
                .eq(Member::getOpenid, dto.getOpenid()), false);
        if (member == null) {
            member = new Member();
            member.setOpenid(dto.getOpenid());
            member.setUnionid(dto.getUnionid());
            member.setNickname(dto.getNickname() == null ? "微信用户" : dto.getNickname());
            member.setAvatar(dto.getAvatar());
            member.setPhone(dto.getPhone());
            member.setGender(dto.getGender());
            member.setBalance(BigDecimal.ZERO);
            member.setPoints(0);
            member.setTotalAmount(BigDecimal.ZERO);
            member.setLevelId(1L);
            member.setStatus(1);
            memberService.save(member);
        } else {
            Member update = new Member();
            update.setId(member.getId());
            update.setNickname(dto.getNickname());
            update.setAvatar(dto.getAvatar());
            update.setUnionid(dto.getUnionid());
            memberService.updateById(update);
        }
        return memberService.getById(member.getId());
    }

    public Member member(Long id) {
        Member member = memberService.getById(id);
        if (member == null) {
            throw new BizException("会员不存在");
        }
        return member;
    }

    /** C 端下单 */
    @Transactional(rollbackFor = Exception.class)
    public OrderInfo createOrder(PortalOrderDTO dto) {
        if (dto == null || dto.getItems() == null || dto.getItems().isEmpty()) {
            throw new BizException("购物车为空");
        }
        if (dto.getStoreId() == null) {
            throw new BizException("请选择门店");
        }
        String orderNo = BizNoUtil.next("ZS");
        BigDecimal total = BigDecimal.ZERO;
        BigDecimal splitFeeTotal = BigDecimal.ZERO;

        List<OrderItem> items = new ArrayList<>();
        for (PortalOrderDTO.Item item : dto.getItems()) {
            BigDecimal price = item.getPrice() == null ? BigDecimal.ZERO : item.getPrice();
            int quantity = item.getQuantity() == null ? 1 : item.getQuantity();
            BigDecimal amount = price.multiply(BigDecimal.valueOf(quantity)).setScale(2, RoundingMode.HALF_UP);
            BigDecimal splitFee = item.getSplitFee() == null ? BigDecimal.ZERO : item.getSplitFee();
            total = total.add(amount);
            splitFeeTotal = splitFeeTotal.add(splitFee);

            OrderItem entity = new OrderItem();
            entity.setOrderNo(orderNo);
            entity.setProductId(item.getProductId());
            entity.setSkuId(item.getSkuId());
            entity.setProductName(item.getProductName());
            entity.setSkuName(item.getSkuName());
            entity.setCover(item.getCover());
            entity.setPrice(price);
            entity.setQuantity(quantity);
            entity.setWeight(item.getWeight());
            entity.setAmount(amount);
            entity.setSplitType(item.getSplitType());
            entity.setSplitFee(splitFee);
            items.add(entity);
        }

        // 配送费：按门店配置，满额免配送
        BigDecimal deliveryFee = BigDecimal.ZERO;
        if ("DELIVERY".equalsIgnoreCase(dto.getDeliveryType())) {
            Store store = storeService.getById(dto.getStoreId());
            if (store != null) {
                BigDecimal free = store.getFreeDeliveryAmount();
                deliveryFee = (free != null && total.compareTo(free) >= 0) ? BigDecimal.ZERO
                        : (store.getDeliveryFee() == null ? BigDecimal.ZERO : store.getDeliveryFee());
            }
        }

        OrderInfo order = new OrderInfo();
        order.setOrderNo(orderNo);
        order.setMemberId(dto.getMemberId());
        order.setStoreId(dto.getStoreId());
        order.setOrderType(dto.getOrderType());
        order.setSource(dto.getSource());
        order.setStatus("UNPAID");
        order.setDeliveryType(dto.getDeliveryType());
        order.setAppointDate(dto.getAppointDate());
        order.setAppointSlot(dto.getAppointSlot());
        order.setReceiverName(dto.getReceiverName());
        order.setReceiverPhone(dto.getReceiverPhone());
        order.setReceiverAddress(dto.getReceiverAddress());
        order.setRemark(dto.getRemark());
        order.setChannelId(dto.getChannelId());
        order.setTotalAmount(total);
        order.setSplitFee(splitFeeTotal);
        order.setDeliveryFee(deliveryFee);
        order.setDiscountAmount(BigDecimal.ZERO);
        order.setPayAmount(total.add(splitFeeTotal).add(deliveryFee));
        order.setPayStatus("UNPAID");
        orderInfoService.save(order);

        for (OrderItem item : items) {
            item.setOrderId(order.getId());
            orderItemService.save(item);
        }

        OrderLog log = new OrderLog();
        log.setOrderId(order.getId());
        log.setOrderNo(orderNo);
        log.setFromStatus(null);
        log.setToStatus("UNPAID");
        log.setOperator("customer");
        log.setRemark("客户下单");
        orderLogService.save(log);

        return order;
    }

    public PageResult<OrderInfo> memberOrders(Long memberId, String status, long current, long size) {
        if (memberId == null) {
            throw new BizException("缺少会员标识");
        }
        Page<OrderInfo> page = orderInfoService.page(new Page<>(current, Math.min(size, 50)),
                new LambdaQueryWrapper<OrderInfo>()
                        .eq(OrderInfo::getMemberId, memberId)
                        .eq(status != null && !status.isBlank(), OrderInfo::getStatus, status)
                        .orderByDesc(OrderInfo::getId));
        return PageResult.of(page);
    }

    public Map<String, Object> orderDetail(String orderNo) {
        OrderInfo order = orderInfoService.getOne(new LambdaQueryWrapper<OrderInfo>()
                .eq(OrderInfo::getOrderNo, orderNo), false);
        if (order == null) {
            throw new BizException("订单不存在");
        }
        Map<String, Object> result = new HashMap<>();
        result.put("order", order);
        result.put("items", orderItemService.list(new LambdaQueryWrapper<OrderItem>()
                .eq(OrderItem::getOrderId, order.getId())));
        return result;
    }

    public List<ProductSku> skus(Long productId) {
        return productService.skus(productId);
    }
}
