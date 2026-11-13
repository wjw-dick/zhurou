package com.zhushi.portal.controller;

import com.zhushi.cms.entity.CmsArticle;
import com.zhushi.cms.entity.CmsBanner;
import com.zhushi.cms.entity.CmsCategory;
import com.zhushi.cms.entity.CmsMessage;
import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RateLimit;
import com.zhushi.common.core.PageResult;
import com.zhushi.common.core.R;
import com.zhushi.member.entity.Coupon;
import com.zhushi.member.entity.Member;
import com.zhushi.order.entity.OrderInfo;
import com.zhushi.portal.dto.PortalLoginDTO;
import com.zhushi.portal.dto.PortalOrderDTO;
import com.zhushi.portal.service.PortalService;
import com.zhushi.product.entity.Product;
import com.zhushi.product.entity.ProductCategory;
import com.zhushi.product.entity.ProductSku;
import com.zhushi.reserve.entity.ReserveConfig;
import com.zhushi.reserve.dto.ReserveBookingDTO;
import com.zhushi.reserve.service.ReserveStockService;
import com.zhushi.store.entity.Store;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * 对外公开接口（无需登录）：微信小程序 / PC 官网 / H5 共用
 * 路径前缀 /api/public/**，已在 SecurityConfig 白名单中放行。
 */
@Tag(name = "对外门户接口")
@RestController
@RequestMapping("/public")
@RequiredArgsConstructor
public class PortalController {

    private final PortalService portalService;
    private final ReserveStockService reserveStockService;

    /* ---------------- 站点与导航 ---------------- */

    @Operation(summary = "站点配置")
    @GetMapping("/config")
    public R<Map<String, String>> config() {
        return R.ok(portalService.siteConfig());
    }

    @Operation(summary = "导航菜单")
    @GetMapping("/menus/{platform}")
    public R<Object> menus(@PathVariable String platform) {
        return R.ok(portalService.navMenus(platform.toUpperCase()));
    }

    @Operation(summary = "Banner 列表")
    @GetMapping("/banners")
    public R<List<CmsBanner>> banners(@RequestParam(required = false) String position) {
        return R.ok(portalService.banners(position));
    }

    /* ---------------- 商品 ---------------- */

    @Operation(summary = "商品分类")
    @GetMapping("/categories")
    public R<List<ProductCategory>> categories(@RequestParam(required = false) String bizType) {
        return R.ok(portalService.categories(bizType));
    }

    @Operation(summary = "商品分类树")
    @GetMapping("/categories/tree")
    public R<List<ProductCategory>> categoryTree(@RequestParam(required = false) String bizType) {
        return R.ok(portalService.categoryTree(bizType));
    }

    @Operation(summary = "商品分页")
    @GetMapping("/products")
    public R<PageResult<Product>> products(@RequestParam(required = false) Long categoryId,
                                           @RequestParam(required = false) String bizType,
                                           @RequestParam(required = false) String keyword,
                                           @RequestParam(required = false) Integer reservable,
                                           @RequestParam(defaultValue = "1") long current,
                                           @RequestParam(defaultValue = "10") long size) {
        return R.ok(portalService.products(categoryId, bizType, keyword, reservable, current, size));
    }

    @Operation(summary = "商品详情")
    @GetMapping("/products/{id}")
    public R<Map<String, Object>> productDetail(@PathVariable Long id) {
        return R.ok(portalService.productDetail(id));
    }

    @Operation(summary = "商品规格")
    @GetMapping("/products/{id}/skus")
    public R<List<ProductSku>> skus(@PathVariable Long id) {
        return R.ok(portalService.skus(id));
    }

    /* ---------------- 门店与预订 ---------------- */

    @Operation(summary = "门店列表")
    @GetMapping("/stores")
    public R<List<Store>> stores() {
        return R.ok(portalService.stores());
    }

    @Operation(summary = "门店详情")
    @GetMapping("/stores/{id}")
    public R<Store> store(@PathVariable Long id) {
        return R.ok(portalService.store(id));
    }

    @Operation(summary = "鲜肉预订配置")
    @GetMapping("/reserve/config")
    public R<ReserveConfig> reserveConfig(@RequestParam(required = false) Long storeId) {
        return R.ok(portalService.reserveConfig(storeId));
    }

    @Operation(summary = "备货量查询")
    @GetMapping("/reserve/stocks")
    public R<Object> reserveStocks(@RequestParam(required = false) Long storeId,
                                   @RequestParam(required = false) LocalDate reserveDate) {
        return R.ok(reserveStockService.summary(reserveDate, storeId));
    }

    @Operation(summary = "预订扣减")
    @RateLimit(seconds = 60, count = 30, message = "操作过于频繁，请稍后再试")
    @PostMapping("/reserve/booking")
    public R<Void> booking(@RequestBody ReserveBookingDTO dto) {
        reserveStockService.booking(dto);
        return R.ok("预订成功", null);
    }

    /* ---------------- 官网 CMS ---------------- */

    @Operation(summary = "文章分页")
    @GetMapping("/articles")
    public R<PageResult<CmsArticle>> articles(@RequestParam(required = false) Long categoryId,
                                              @RequestParam(required = false) String articleType,
                                              @RequestParam(defaultValue = "1") long current,
                                              @RequestParam(defaultValue = "10") long size) {
        return R.ok(portalService.articles(categoryId, articleType, current, size));
    }

    @Operation(summary = "文章详情")
    @GetMapping("/articles/{id}")
    public R<CmsArticle> article(@PathVariable Long id) {
        return R.ok(portalService.article(id));
    }

    @Operation(summary = "CMS 栏目")
    @GetMapping("/cms/categories")
    public R<List<CmsCategory>> cmsCategories() {
        return R.ok(portalService.cmsCategories());
    }

    @Operation(summary = "提交留言/团购咨询")
    @OperationLog(module = "门户留言", action = "提交")
    @RateLimit(seconds = 60, count = 5, message = "提交过于频繁，请稍后再试")
    @PostMapping("/message")
    public R<Void> message(@RequestBody CmsMessage message) {
        portalService.submitMessage(message);
        return R.ok("提交成功", null);
    }

    /* ---------------- 会员与订单 ---------------- */

    @Operation(summary = "优惠券列表")
    @GetMapping("/coupons")
    public R<List<Coupon>> coupons() {
        return R.ok(portalService.coupons());
    }

    @Operation(summary = "微信登录（openid 自动注册会员）")
    @OperationLog(module = "门户会员", action = "登录")
    @PostMapping("/login")
    public R<Member> login(@RequestBody PortalLoginDTO dto) {
        return R.ok("登录成功", portalService.login(dto));
    }

    @Operation(summary = "会员信息")
    @GetMapping("/member/{id}")
    public R<Member> member(@PathVariable Long id) {
        return R.ok(portalService.member(id));
    }

    @Operation(summary = "会员订单")
    @GetMapping("/orders")
    public R<PageResult<OrderInfo>> orders(@RequestParam Long memberId,
                                           @RequestParam(required = false) String status,
                                           @RequestParam(defaultValue = "1") long current,
                                           @RequestParam(defaultValue = "10") long size) {
        return R.ok(portalService.memberOrders(memberId, status, current, size));
    }

    @Operation(summary = "订单详情（按订单号）")
    @GetMapping("/orders/{orderNo}")
    public R<Map<String, Object>> orderDetail(@PathVariable String orderNo) {
        return R.ok(portalService.orderDetail(orderNo));
    }

    @Operation(summary = "下单")
    @OperationLog(module = "门户订单", action = "下单")
    @RateLimit(seconds = 60, count = 20, message = "下单过于频繁，请稍后再试")
    @PostMapping("/orders")
    public R<OrderInfo> createOrder(@RequestBody PortalOrderDTO dto) {
        return R.ok("下单成功", portalService.createOrder(dto));
    }
}
