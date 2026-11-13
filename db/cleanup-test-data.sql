-- 清理冒烟测试产生的数据，恢复初始种子状态
USE `zhushu`;

-- 1) 测试商品（原始商品 id 1-9）
DELETE FROM `product_sku` WHERE `product_id` > 9;
DELETE FROM `product_qualification` WHERE `product_id` > 9;
DELETE FROM `product_store` WHERE `product_id` > 9;
DELETE FROM `product` WHERE `id` > 9;

-- 2) 测试订单（原始订单 id 1-4）
DELETE FROM `order_item` WHERE `order_id` > 4;
DELETE FROM `order_log` WHERE `order_id` > 4;
DELETE FROM `order_info` WHERE `id` > 4;

-- 3) 测试会员（openid 为固定测试值）
DELETE FROM `member_balance_log` WHERE `member_id` NOT IN (1,2,3);
DELETE FROM `member_points_log` WHERE `member_id` NOT IN (1,2,3);
DELETE FROM `member` WHERE `openid` = 'oTestSmoke001';

-- 4) 测试留言
DELETE FROM `cms_message`;

-- 5) 测试门店
DELETE FROM `store` WHERE `code` IN ('S900','S901');

-- 6) 测试渠道报单
DELETE FROM `channel_order` WHERE `report_no` LIKE 'RPT-TEST%';

-- 7) 还原鲜肉预订已订量（测试预订扣减 +5）
UPDATE `reserve_stock` SET `booked` = 12 WHERE `store_id` = 1 AND `product_id` = 1 AND `sku_id` = 1;

-- 8) 还原「店长」角色菜单授权
DELETE FROM `sys_role_menu` WHERE `role_id` = 2;
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 2, `id` FROM `sys_menu` WHERE `platform`='ADMIN' AND (
  `id` IN (1,20,120) OR `parent_id` IN (20,30,40,50,90) OR `id` IN (30,40,50,90)
  OR `parent_id` IN (301,302,401,402,403,501,50101,902,903,904,905)
  OR `id` IN (301,302,401,402,403,501,902,903,904,905));

SELECT
  (SELECT COUNT(*) FROM `product`)       AS products,
  (SELECT COUNT(*) FROM `store`)         AS stores,
  (SELECT COUNT(*) FROM `order_info`)    AS orders,
  (SELECT COUNT(*) FROM `member`)        AS members,
  (SELECT COUNT(*) FROM `cms_message`)   AS messages,
  (SELECT COUNT(*) FROM `channel_order`) AS channel_orders,
  (SELECT COUNT(*) FROM `sys_role_menu`) AS role_menus,
  (SELECT SUM(`booked`) FROM `reserve_stock`) AS reserved;
