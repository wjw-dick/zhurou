-- =============================================================
-- 猪事大吉 · 初始化数据
-- 超管账号：admin / admin123（首次登录后请立即修改）
-- 说明：超级管理员 is_super=1，后端对超管放行全部功能(全量维护)；
--       菜单含五套平台(ADMIN/PC/WECHAT/MINIAPP/H5)，可在「菜单维护」中增删改+拖拽排序。
-- =============================================================
USE `zhushu`;
SET NAMES utf8mb4;

-- ---------- 用户 ----------
DELETE FROM `sys_user` WHERE `username` IN ('admin','store01','finance01','clerk01','cutter01','service01','supplier01','channel01');
INSERT INTO `sys_user` (`id`,`username`,`password`,`nickname`,`real_name`,`phone`,`user_type`,`is_super`,`status`,`remark`) VALUES
(1,'admin',      '$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','超级管理员','超级管理员','13800000000','ADMIN',          1,1,'超级管理员(全量维护)'),
(2,'store01',    '$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','西城店店长','王店长',  '13800000001','STORE_MANAGER',  0,1,NULL),
(3,'finance01',  '$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','财务小李',  '李财务',  '13800000002','FINANCE',        0,1,NULL),
(4,'clerk01',    '$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','店员小张',  '张店员',  '13800000003','CLERK',          0,1,NULL),
(5,'cutter01',   '$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','分割师傅',  '赵师傅',  '13800000004','CUTTER',         0,1,NULL),
(6,'service01',  '$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','客服小刘',  '刘客服',  '13800000005','SERVICE',        0,1,NULL),
(7,'supplier01', '$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','供货商账号','某供应商','13800000006','SUPPLIER',       0,1,NULL),
(8,'channel01',  '$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','渠道商账号','某渠道商','13800000007','CHANNEL',        0,1,NULL);

-- ---------- 角色 ----------
DELETE FROM `sys_role`;
INSERT INTO `sys_role` (`id`,`code`,`name`,`platform`,`data_scope`,`sort`,`status`,`remark`) VALUES
(1,'SUPER_ADMIN','超级管理员','ADMIN','ALL',1,1,'拥有全部功能维护权限'),
(2,'STORE_MANAGER','店长','ADMIN','STORE',2,1,'门店数据'),
(3,'FINANCE','财务','ADMIN','ALL',3,1,'结算/对账'),
(4,'CLERK','店员','STAFF','STORE',4,1,NULL),
(5,'CUTTER','分割师傅','STAFF','STORE',5,1,NULL),
(6,'SERVICE','客服','ADMIN','ALL',6,1,NULL),
(7,'SUPPLIER','供应商管理员','SUPPLIER','SELF',7,1,NULL),
(8,'CHANNEL','渠道商管理员','CHANNEL','SELF',8,1,NULL);

DELETE FROM `sys_user_role`;
INSERT INTO `sys_user_role` (`user_id`,`role_id`) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8);

-- =============================================================
-- 菜单（ADMIN 后台）
-- =============================================================
DELETE FROM `sys_menu`;

-- 工作台
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(1, 0,'ADMIN','MENU','工作台','Dashboard','/dashboard','dashboard/index','ep:home-filled','dashboard:view',1,1,1,1);

-- 系统管理
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(10,0,'ADMIN','DIR','系统管理','System','/system',NULL,'ep:setting','',10,1,1,1),
(101,10,'ADMIN','MENU','用户管理','Users','/system/user','system/user/index','ep:user','sys:user:list',1,1,1,1),
(102,10,'ADMIN','MENU','角色管理','Roles','/system/role','system/role/index','ep:avatar','sys:role:list',2,1,1,1),
(103,10,'ADMIN','MENU','菜单维护','Menus','/system/menu','system/menu/index','ep:menu','sys:menu:list',3,1,1,1),
(104,10,'ADMIN','MENU','系统参数','Config','/system/config','system/config/index','ep:tools','sys:config:list',4,1,1,1),
(105,10,'ADMIN','MENU','数据字典','Dict','/system/dict','system/dict/index','ep:notebook','sys:dict:list',5,1,1,1),
(106,10,'ADMIN','MENU','多语言','I18n','/system/i18n','system/i18n/index','ep:chat-dot-square','sys:i18n:list',6,1,1,1),
(107,10,'ADMIN','MENU','审计日志','AuditLog','/system/audit','system/audit/index','ep:document','sys:audit:list',7,1,0,1),
(108,10,'ADMIN','MENU','对象存储','ObjectStorage','/system/oss','system/oss/index','ep:files','oss:config:list',8,1,1,1);

-- 门店
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(20,0,'ADMIN','MENU','门店管理','Stores','/store/list','store/index','ep:shop','store:info:list',20,1,1,1);

-- 商品
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(30,0,'ADMIN','DIR','商品管理','Product','/product',NULL,'ep:goods','',30,1,1,1),
(301,30,'ADMIN','MENU','商品分类','Categories','/product/category','product/category/index','ep:grid','product:category:list',1,1,1,1),
(302,30,'ADMIN','MENU','商品列表','Products','/product/list','product/index','ep:dish','product:info:list',2,1,1,1),
(303,30,'ADMIN','MENU','检疫资质','Qualifications','/product/qualification','product/qualification/index','ep:stamp','product:qualification:list',3,1,1,1);

-- 鲜肉预订
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(40,0,'ADMIN','DIR','鲜肉预订','Reserve','/reserve',NULL,'ep:timer','',40,1,1,1),
(401,40,'ADMIN','MENU','预订单','ReserveOrders','/reserve/order','reserve/order/index','ep:list','reserve:order:list',1,1,1,1),
(402,40,'ADMIN','MENU','备货量','ReserveStock','/reserve/stock','reserve/stock/index','ep:box','reserve:stock:list',2,1,1,1),
(403,40,'ADMIN','MENU','预订配置','ReserveConfig','/reserve/config','reserve/config/index','ep:set-up','reserve:config:list',3,1,1,1);

-- 订单
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(50,0,'ADMIN','DIR','订单中心','Order','/order',NULL,'ep:tickets','',50,1,1,1),
(501,50,'ADMIN','MENU','订单管理','Orders','/order/list','order/index','ep:document-copy','order:info:list',1,1,1,1),
(502,50,'ADMIN','MENU','售后管理','Aftersale','/order/aftersale','order/aftersale/index','ep:refresh-left','order:aftersale:list',2,1,1,1);

-- 会员营销
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(60,0,'ADMIN','DIR','会员营销','Member','/member',NULL,'ep:user-filled','',60,1,1,1),
(601,60,'ADMIN','MENU','会员管理','Members','/member/list','member/index','ep:star','member:info:list',1,1,1,1),
(602,60,'ADMIN','MENU','会员等级','Levels','/member/level','member/level/index','ep:medal','member:level:list',2,1,1,1),
(603,60,'ADMIN','MENU','优惠券','Coupons','/member/coupon','member/coupon/index','ep:discount','member:coupon:list',3,1,1,1),
(604,60,'ADMIN','MENU','储值记录','BalanceLogs','/member/balance','member/balance/index','ep:wallet','member:balance:list',4,1,0,1),
(605,60,'ADMIN','MENU','积分记录','PointsLogs','/member/points','member/points/index','ep:coin','member:points:list',5,1,0,1);

-- 供应商
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(70,0,'ADMIN','DIR','供应商管理','Supplier','/supplier',NULL,'ep:truck','',70,1,1,1),
(701,70,'ADMIN','MENU','供应商档案','Suppliers','/supplier/list','supplier/index','ep:office-building','supplier:info:list',1,1,1,1),
(702,70,'ADMIN','MENU','供货协议','Agreements','/supplier/agreement','supplier/agreement/index','ep:document-checked','supplier:agreement:list',2,1,0,1),
(703,70,'ADMIN','MENU','资质审核','Qualifications','/supplier/qualification','supplier/qualification/index','ep:stamp','supplier:qualification:list',3,1,1,1),
(704,70,'ADMIN','MENU','采购计划','Plans','/supplier/plan','supplier/plan/index','ep:calendar','purchase:plan:list',4,1,0,1),
(705,70,'ADMIN','MENU','供货单','Purchases','/supplier/purchase','supplier/purchase/index','ep:shopping-cart','purchase:order:list',5,1,1,1),
(706,70,'ADMIN','MENU','送货单','Deliveries','/supplier/delivery','supplier/delivery/index','ep:van','supplier:delivery:list',6,1,0,1),
(707,70,'ADMIN','MENU','对账结算','Settlement','/supplier/settlement','supplier/settlement/index','ep:money','supplier:settlement:list',7,1,1,1),
(708,70,'ADMIN','MENU','库存预警','Warning','/supplier/warning','supplier/warning/index','ep:warning','inventory:warning:list',8,1,1,1),
(709,70,'ADMIN','MENU','出入库','Inventory','/supplier/inventory','supplier/inventory/index','ep:files','inventory:record:list',9,1,0,1);

-- 渠道商
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(80,0,'ADMIN','DIR','渠道商管理','Channel','/channel',NULL,'ep:share','',80,1,1,1),
(801,80,'ADMIN','MENU','渠道档案','Channels','/channel/list','channel/index','ep:connection','channel:info:list',1,1,1,1),
(802,80,'ADMIN','MENU','佣金规则','CommissionRules','/channel/rule','channel/rule/index','ep:coin','channel:rule:list',2,1,1,1),
(803,80,'ADMIN','MENU','报单审核','ChannelOrders','/channel/order','channel/order/index','ep:edit-pen','channel:order:list',3,1,1,1),
(804,80,'ADMIN','MENU','渠道结算','ChannelSettlement','/channel/settlement','channel/settlement/index','ep:money','channel:settlement:list',4,1,1,1),
(805,80,'ADMIN','MENU','渠道专属价','ChannelPrice','/channel/price','channel/price/index','ep:price-tag','channel:price:list',5,1,0,1);

-- 店员
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(90,0,'ADMIN','DIR','店员管理','Staff','/staff',NULL,'ep:user','',90,1,1,1),
(901,90,'ADMIN','MENU','店员档案','Staffs','/staff/list','staff/index','ep:postcard','staff:info:list',1,1,1,1),
(902,90,'ADMIN','MENU','备货待办','Tasks','/staff/task','staff/task/index','ep:finished','staff:task:list',2,1,1,1),
(903,90,'ADMIN','MENU','分割登记','SplitRecords','/staff/split','staff/split/index','ep:scissor','staff:split:list',3,1,1,1),
(904,90,'ADMIN','MENU','称重开单','StaffOrders','/staff/order','staff/order/index','ep:scale-to-original','staff:order:list',4,1,1,1),
(905,90,'ADMIN','MENU','业绩提成','Performance','/staff/performance','staff/performance/index','ep:trend-charts','staff:performance:list',5,1,1,1);

-- CMS
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(100,0,'ADMIN','DIR','官网 CMS','CMS','/cms',NULL,'ep:collection','',100,1,1,1),
(1001,100,'ADMIN','MENU','栏目管理','Categories','/cms/category','cms/category/index','ep:folder','cms:category:list',1,1,0,1),
(1002,100,'ADMIN','MENU','文章资讯','Articles','/cms/article','cms/article/index','ep:reading','cms:article:list',2,1,1,1),
(1003,100,'ADMIN','MENU','Banner','Banners','/cms/banner','cms/banner/index','ep:picture','cms:banner:list',3,1,0,1),
(1004,100,'ADMIN','MENU','留言管理','Messages','/cms/message','cms/message/index','ep:message','cms:message:list',4,1,1,1);

-- 微信
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(110,0,'ADMIN','DIR','微信管理','WeChat','/wechat',NULL,'ep:chat-line-round','',110,1,1,1),
(1101,110,'ADMIN','MENU','公众号菜单','MP Menus','/wechat/menu','wechat/menu/index','ep:menu','wechat:menu:list',1,1,1,1),
(1102,110,'ADMIN','MENU','模板消息','Templates','/wechat/template','wechat/template/index','ep:bell','wechat:template:list',2,1,0,1),
(1103,110,'ADMIN','MENU','发送日志','Msg Logs','/wechat/log','wechat/log/index','ep:document','wechat:log:list',3,1,0,1);

-- 数据看板
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`component`,`icon`,`perm`,`sort`,`visible`,`keep_alive`,`status`) VALUES
(120,0,'ADMIN','MENU','数据看板','Analysis','/analysis','analysis/index','ep:data-analysis','analysis:view',120,1,1,1);

-- =============================================================
-- 按钮权限（超管自动放行，此处用于授权其他角色）
-- =============================================================
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`perm`,`sort`,`status`) VALUES
(10101,101,'ADMIN','BUTTON','用户新增','sys:user:add',1,1),
(10102,101,'ADMIN','BUTTON','用户编辑','sys:user:edit',2,1),
(10103,101,'ADMIN','BUTTON','用户删除','sys:user:del',3,1),
(10104,101,'ADMIN','BUTTON','重置密码','sys:user:resetPwd',4,1),
(10201,102,'ADMIN','BUTTON','角色新增','sys:role:add',1,1),
(10202,102,'ADMIN','BUTTON','角色编辑','sys:role:edit',2,1),
(10203,102,'ADMIN','BUTTON','角色删除','sys:role:del',3,1),
(10204,102,'ADMIN','BUTTON','分配权限','sys:role:assign',4,1),
(10301,103,'ADMIN','BUTTON','菜单新增','sys:menu:add',1,1),
(10302,103,'ADMIN','BUTTON','菜单编辑','sys:menu:edit',2,1),
(10303,103,'ADMIN','BUTTON','菜单删除','sys:menu:del',3,1),
(10304,103,'ADMIN','BUTTON','拖拽排序','sys:menu:sort',4,1),
(10401,104,'ADMIN','BUTTON','参数新增','sys:config:add',1,1),
(10402,104,'ADMIN','BUTTON','参数编辑','sys:config:edit',2,1),
(10403,104,'ADMIN','BUTTON','参数删除','sys:config:del',3,1),
(10501,105,'ADMIN','BUTTON','字典新增','sys:dict:add',1,1),
(10502,105,'ADMIN','BUTTON','字典编辑','sys:dict:edit',2,1),
(10503,105,'ADMIN','BUTTON','字典删除','sys:dict:del',3,1),
(10601,106,'ADMIN','BUTTON','词条新增','sys:i18n:add',1,1),
(10602,106,'ADMIN','BUTTON','词条编辑','sys:i18n:edit',2,1),
(10603,106,'ADMIN','BUTTON','词条删除','sys:i18n:del',3,1),
(10801,108,'ADMIN','BUTTON','保存配置','oss:config:edit',1,1),
(10802,108,'ADMIN','BUTTON','连接测试','oss:config:test',2,1),
(2001,20,'ADMIN','BUTTON','门店新增','store:info:add',1,1),
(2002,20,'ADMIN','BUTTON','门店编辑','store:info:edit',2,1),
(2003,20,'ADMIN','BUTTON','门店删除','store:info:del',3,1),
(30101,301,'ADMIN','BUTTON','分类新增','product:category:add',1,1),
(30102,301,'ADMIN','BUTTON','分类编辑','product:category:edit',2,1),
(30103,301,'ADMIN','BUTTON','分类删除','product:category:del',3,1),
(30201,302,'ADMIN','BUTTON','商品新增','product:info:add',1,1),
(30202,302,'ADMIN','BUTTON','商品编辑','product:info:edit',2,1),
(30203,302,'ADMIN','BUTTON','商品删除','product:info:del',3,1),
(30204,302,'ADMIN','BUTTON','商品审核','product:info:audit',4,1),
(30205,302,'ADMIN','BUTTON','上下架','product:info:status',5,1),
(30301,303,'ADMIN','BUTTON','资质新增','product:qualification:add',1,1),
(30302,303,'ADMIN','BUTTON','资质编辑','product:qualification:edit',2,1),
(30303,303,'ADMIN','BUTTON','资质删除','product:qualification:del',3,1),
(40101,401,'ADMIN','BUTTON','订单备货','reserve:order:prepare',1,1),
(40102,401,'ADMIN','BUTTON','订单取消','reserve:order:cancel',2,1),
(40201,402,'ADMIN','BUTTON','设置备货量','reserve:stock:edit',1,1),
(40301,403,'ADMIN','BUTTON','配置编辑','reserve:config:edit',1,1),
(50101,501,'ADMIN','BUTTON','订单发货','order:info:deliver',1,1),
(50102,501,'ADMIN','BUTTON','订单完成','order:info:finish',2,1),
(50103,501,'ADMIN','BUTTON','订单取消','order:info:cancel',3,1),
(50104,501,'ADMIN','BUTTON','订单导出','order:info:export',4,1),
(50201,502,'ADMIN','BUTTON','售后审核','order:aftersale:audit',1,1),
(50202,502,'ADMIN','BUTTON','发起退款','order:aftersale:refund',2,1),
(60101,601,'ADMIN','BUTTON','会员编辑','member:info:edit',1,1),
(60102,601,'ADMIN','BUTTON','会员充值','member:info:recharge',2,1),
(60103,601,'ADMIN','BUTTON','积分调整','member:info:points',3,1),
(60201,602,'ADMIN','BUTTON','等级新增','member:level:add',1,1),
(60202,602,'ADMIN','BUTTON','等级编辑','member:level:edit',2,1),
(60203,602,'ADMIN','BUTTON','等级删除','member:level:del',3,1),
(60301,603,'ADMIN','BUTTON','券新增','member:coupon:add',1,1),
(60302,603,'ADMIN','BUTTON','券编辑','member:coupon:edit',2,1),
(60303,603,'ADMIN','BUTTON','券删除','member:coupon:del',3,1),
(70101,701,'ADMIN','BUTTON','供应商新增','supplier:info:add',1,1),
(70102,701,'ADMIN','BUTTON','供应商编辑','supplier:info:edit',2,1),
(70103,701,'ADMIN','BUTTON','供应商删除','supplier:info:del',3,1),
(70201,702,'ADMIN','BUTTON','协议新增','supplier:agreement:add',1,1),
(70202,702,'ADMIN','BUTTON','协议编辑','supplier:agreement:edit',2,1),
(70301,703,'ADMIN','BUTTON','资质审核','supplier:qualification:audit',1,1),
(70401,704,'ADMIN','BUTTON','计划生成','purchase:plan:generate',1,1),
(70501,705,'ADMIN','BUTTON','供货单新增','purchase:order:add',1,1),
(70502,705,'ADMIN','BUTTON','供货单编辑','purchase:order:edit',2,1),
(70503,705,'ADMIN','BUTTON','入库','purchase:order:receive',3,1),
(70701,707,'ADMIN','BUTTON','生成对账单','supplier:settlement:generate',1,1),
(70702,707,'ADMIN','BUTTON','确认结算','supplier:settlement:confirm',2,1),
(70801,708,'ADMIN','BUTTON','处理预警','inventory:warning:handle',1,1),
(80101,801,'ADMIN','BUTTON','渠道新增','channel:info:add',1,1),
(80102,801,'ADMIN','BUTTON','渠道编辑','channel:info:edit',2,1),
(80103,801,'ADMIN','BUTTON','渠道删除','channel:info:del',3,1),
(80201,802,'ADMIN','BUTTON','规则新增','channel:rule:add',1,1),
(80202,802,'ADMIN','BUTTON','规则编辑','channel:rule:edit',2,1),
(80203,802,'ADMIN','BUTTON','规则删除','channel:rule:del',3,1),
(80301,803,'ADMIN','BUTTON','报单审核','channel:order:audit',1,1),
(80401,804,'ADMIN','BUTTON','生成结算单','channel:settlement:generate',1,1),
(80402,804,'ADMIN','BUTTON','确认打款','channel:settlement:pay',2,1),
(90101,901,'ADMIN','BUTTON','店员新增','staff:info:add',1,1),
(90102,901,'ADMIN','BUTTON','店员编辑','staff:info:edit',2,1),
(90103,901,'ADMIN','BUTTON','店员删除','staff:info:del',3,1),
(90201,902,'ADMIN','BUTTON','派单','staff:task:assign',1,1),
(90301,903,'ADMIN','BUTTON','分割登记','staff:split:add',1,1),
(90401,904,'ADMIN','BUTTON','称重开单','staff:order:add',1,1),
(100201,1002,'ADMIN','BUTTON','文章新增','cms:article:add',1,1),
(100202,1002,'ADMIN','BUTTON','文章编辑','cms:article:edit',2,1),
(100203,1002,'ADMIN','BUTTON','文章删除','cms:article:del',3,1),
(100401,1004,'ADMIN','BUTTON','留言处理','cms:message:handle',1,1),
(110101,1101,'ADMIN','BUTTON','菜单新增','wechat:menu:add',1,1),
(110102,1101,'ADMIN','BUTTON','菜单编辑','wechat:menu:edit',2,1),
(110103,1101,'ADMIN','BUTTON','菜单删除','wechat:menu:del',3,1),
(110104,1101,'ADMIN','BUTTON','预览到微信','wechat:menu:preview',4,1),
(110105,1101,'ADMIN','BUTTON','发布菜单','wechat:menu:publish',5,1);

-- =============================================================
-- 其他端菜单：PC 官网导航 / 公众号菜单 / 小程序 tabBar / H5 底栏
-- =============================================================
INSERT INTO `sys_menu` (`id`,`parent_id`,`platform`,`menu_type`,`name`,`name_en`,`path`,`icon`,`link_type`,`appid`,`page_path`,`sort`,`visible`,`status`) VALUES
(90001,0,'PC','LINK','首页','Home','/','',NULL,NULL,NULL,1,1,1),
(90002,0,'PC','LINK','品牌故事','Brand','/brand','',NULL,NULL,NULL,2,1,1),
(90003,0,'PC','LINK','产品展示','Products','/products','',NULL,NULL,NULL,3,1,1),
(90004,0,'PC','LINK','门店导航','Stores','/stores','',NULL,NULL,NULL,4,1,1),
(90005,0,'PC','LINK','新闻资讯','News','/news','',NULL,NULL,NULL,5,1,1),
(90006,0,'PC','LINK','联系我们','Contact','/contact','',NULL,NULL,NULL,6,1,1),

(91001,0,'WECHAT','MENU','品牌故事','Brand','','', 'PAGE',NULL,NULL,1,1,1),
(91011,91001,'WECHAT','MENU','猪事大吉的故事','Our Story','','', 'PAGE',NULL,NULL,1,1,1),
(91012,91001,'WECHAT','MENU','鲜肉理念','Fresh Idea','','', 'PAGE',NULL,NULL,2,1,1),
(91002,0,'WECHAT','MENU','门店导航','Stores','','', 'PAGE',NULL,NULL,2,1,1),
(91003,0,'WECHAT','MENU','进入商城','Mall','','', 'MINIAPP',NULL,'pages/index/index',3,1,1),

(92001,0,'MINIAPP','MENU','首页','Home','/pages/index/index','ep:home-filled',NULL,NULL,NULL,1,1,1),
(92002,0,'MINIAPP','MENU','分类','Category','/pages/category/index','ep:grid',NULL,NULL,NULL,2,1,1),
(92003,0,'MINIAPP','MENU','鲜肉预订','Reserve','/pages/reserve/index','ep:timer',NULL,NULL,NULL,3,1,1),
(92004,0,'MINIAPP','MENU','购物车','Cart','/pages/cart/index','ep:shopping-cart',NULL,NULL,NULL,4,1,1),
(92005,0,'MINIAPP','MENU','我的','Mine','/pages/mine/index','ep:user',NULL,NULL,NULL,5,1,1),

(93001,0,'H5','LINK','首页','Home','/','',NULL,NULL,NULL,1,1,1),
(93002,0,'H5','LINK','火锅套餐','Combo','/combo','',NULL,NULL,NULL,2,1,1),
(93003,0,'H5','LINK','我的','Mine','/mine','',NULL,NULL,NULL,3,1,1);

-- 角色-菜单（超管角色也给全量，便于界面展示；超管本身 is_super 已放行）
DELETE FROM `sys_role_menu`;
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`) SELECT 1, `id` FROM `sys_menu`;
-- 店长：门店/商品/预订/订单/店员/看板
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 2, `id` FROM `sys_menu` WHERE `platform`='ADMIN' AND (
  `id` IN (1,20,120) OR `parent_id` IN (20,30,40,50,90) OR `id` IN (30,40,50,90)
  OR `parent_id` IN (301,302,401,402,403,501,50101,902,903,904,905) OR `id` IN (301,302,401,402,403,501,902,903,904,905));
-- 财务：供应商/渠道结算 + 看板
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 3, `id` FROM `sys_menu` WHERE `platform`='ADMIN' AND (`id` IN (1,120,70,80,707,804) OR `parent_id` IN (707,804) );
-- 店员：备货待办/称重开单/业绩
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 4, `id` FROM `sys_menu` WHERE `id` IN (1,902,904,905,90201,90401,90);
-- 分割师傅：分割登记
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 5, `id` FROM `sys_menu` WHERE `id` IN (1,903,90301);
-- 客服：订单/售后/会员/留言
INSERT INTO `sys_role_menu` (`role_id`,`menu_id`)
SELECT 6, `id` FROM `sys_menu` WHERE `platform`='ADMIN' AND (`id` IN (1,50,60,501,502,601,1004,120) OR `parent_id` IN (501,502,601,1004));

-- =============================================================
-- 字典
-- =============================================================
DELETE FROM `sys_dict_type`;
DELETE FROM `sys_dict_data`;
INSERT INTO `sys_dict_type` (`code`,`name`,`sort`,`status`) VALUES
('biz_type','商品品类',1,1),
('order_status','订单状态',2,1),
('order_type','订单类型',3,1),
('delivery_type','收货方式',4,1),
('split_type','分割选项',5,1),
('qual_type','资质类型',6,1),
('pay_type','支付方式',7,1),
('settle_type','结算方式',8,1),
('staff_type','店员类型',9,1),
('channel_type','渠道类型',10,1),
('yes_no','是否',11,1),
('audit_status','审核状态',12,1);

INSERT INTO `sys_dict_data` (`dict_code`,`label`,`label_en`,`value`,`sort`,`status`) VALUES
('biz_type','鲜猪肉','Pork','PORK',1,1),
('biz_type','火锅食材','Hotpot','HOTPOT',2,1),
('biz_type','肉制品','Processed','PROCESSED',3,1),
('biz_type','火锅底料蘸料','Base & Sauce','BASE',4,1),
('biz_type','套餐礼盒','Combo & Gift','SET',5,1),

('order_status','待支付','Unpaid','UNPAID',1,1),
('order_status','待备货','Preparing','PREPARING',2,1),
('order_status','待取货','Ready','READY',3,1),
('order_status','配送中','Delivering','DELIVERING',4,1),
('order_status','已完成','Completed','COMPLETED',5,1),
('order_status','已取消','Cancelled','CANCELLED',6,1),
('order_status','售后','Aftersale','AFTERSALE',7,1),

('order_type','普通订单','Normal','NORMAL',1,1),
('order_type','鲜肉预订','Reserve','RESERVE',2,1),
('order_type','火锅套餐','Hotpot Set','SET',3,1),
('order_type','肉制品礼盒','Gift Box','GIFT',4,1),

('delivery_type','到店自提','Self Pickup','SELF_PICKUP',1,1),
('delivery_type','门店配送','Delivery','DELIVERY',2,1),

('split_type','切块','Cubed','CUBE',1,1),
('split_type','绞肉','Minced','MINCED',2,1),
('split_type','切片','Sliced','SLICED',3,1),
('split_type','不分割','None','NONE',4,1),

('qual_type','动物产品检疫合格证明','Quarantine Cert','QUARANTINE',1,1),
('qual_type','肉品品质检验合格证','Quality Cert','QUALITY',2,1),
('qual_type','食品生产许可(SC)','SC License','SC',3,1),
('qual_type','检测报告','Inspection Report','INSPECTION',4,1),
('qual_type','营业执照','Business License','BUSINESS',5,1),

('pay_type','微信支付','WeChat Pay','WECHAT',1,1),
('pay_type','余额支付','Balance','BALANCE',2,1),
('pay_type','现金','Cash','CASH',3,1),

('settle_type','月结','Monthly','MONTH',1,1),
('settle_type','周结','Weekly','WEEK',2,1),
('settle_type','现结','Cash','CASH',3,1),
('settle_type','按重量','By Weight','WEIGHT',4,1),
('settle_type','按份','By Unit','FIXED',5,1),

('staff_type','店员','Clerk','CLERK',1,1),
('staff_type','分割师傅','Cutter','CUTTER',2,1),

('channel_type','团购','Group Buy','GROUP',1,1),
('channel_type','分销','Distributor','DISTRIBUTOR',2,1),
('channel_type','加盟','Franchise','FRANCHISE',3,1),

('yes_no','是','Yes','1',1,1),
('yes_no','否','No','0',2,1),

('audit_status','待审核','Pending','PENDING',1,1),
('audit_status','已通过','Approved','APPROVED',2,1),
('audit_status','已驳回','Rejected','REJECTED',3,1);

-- =============================================================
-- 多语言
-- =============================================================
DELETE FROM `sys_lang`;
INSERT INTO `sys_lang` (`code`,`name`,`is_default`,`status`,`sort`) VALUES
('zh-CN','简体中文',1,1,1),
('en-US','English',0,1,2);

DELETE FROM `sys_i18n`;
INSERT INTO `sys_i18n` (`lang_code`,`module`,`i18n_key`,`i18n_value`) VALUES
('zh-CN','common','app.name','猪事大吉'),
('en-US','common','app.name','ZhuShi DaJi'),
('zh-CN','common','app.slogan','社区鲜肉 · 火锅食材 · 肉制品'),
('en-US','common','app.slogan','Fresh Meat · Hotpot · Processed Meat'),
('zh-CN','common','action.add','新增'),
('en-US','common','action.add','Add'),
('zh-CN','common','action.edit','编辑'),
('en-US','common','action.edit','Edit'),
('zh-CN','common','action.delete','删除'),
('en-US','common','action.delete','Delete'),
('zh-CN','common','action.search','查询'),
('en-US','common','action.search','Search');

-- =============================================================
-- 系统参数
-- =============================================================
DELETE FROM `sys_config`;
INSERT INTO `sys_config` (`group_code`,`group_name`,`config_key`,`config_name`,`config_value`,`value_type`,`encrypted`,`sort`) VALUES
('site','站点信息','site.name','站点名称','猪事大吉','STRING',0,1),
('site','站点信息','site.logo','站点 Logo','','IMAGE',0,2),
('site','站点信息','site.icp','ICP 备案号','','STRING',0,3),
('site','站点信息','site.copyright','版权信息','© 猪事大吉','STRING',0,4),
('site','站点信息','site.keywords','SEO 关键词','鲜肉,火锅食材,肉制品,猪肉,社区生鲜','STRING',0,5),
('site','站点信息','site.description','SEO 描述','猪事大吉 · 社区一站式鲜肉与火锅食材超市','TEXT',0,6),
('site','站点信息','site.service_phone','客服电话','400-000-0000','STRING',0,7),
('site','站点信息','site.service_qrcode','客服二维码','','IMAGE',0,8),

('wechat','微信配置','wechat.mp_appid','公众号 AppID','','STRING',0,1),
('wechat','微信配置','wechat.mp_secret','公众号 AppSecret','','STRING',1,2),
('wechat','微信配置','wechat.mpp_appid','小程序 AppID','','STRING',0,3),
('wechat','微信配置','wechat.mpp_secret','小程序 AppSecret','','STRING',1,4),
('wechat','微信配置','wechat.pay_mchid','微信支付商户号','','STRING',0,5),
('wechat','微信配置','wechat.pay_apiv3_key','微信支付 APIv3 密钥','','STRING',1,6),
('wechat','微信配置','wechat.pay_cert_path','微信支付证书路径','','STRING',1,7),

('pay','支付配置','pay.expire_minutes','订单支付超时(分钟)','30','NUMBER',0,1),
('pay','支付配置','pay.auto_refund','取消订单自动退款','true','BOOLEAN',0,2),

('delivery','配送配置','delivery.default_fee','默认配送费(元)','5.00','NUMBER',0,1),
('delivery','配送配置','delivery.free_amount','满额免配送费(元)','59.00','NUMBER',0,2),
('delivery','配送配置','delivery.radius_km','默认配送半径(km)','3.00','NUMBER',0,3),
('delivery','配送配置','delivery.min_order_amount','起送金额(元)','20.00','NUMBER',0,4),

('commission','佣金提成','commission.channel_rate','渠道默认佣金比例(%)','8.00','NUMBER',0,1),
('commission','佣金提成','commission.channel_level2_rate','二级渠道佣金比例(%)','3.00','NUMBER',0,2),
('commission','佣金提成','commission.staff_rate','店员默认提成比例(%)','2.00','NUMBER',0,3),

('reserve','鲜肉预订','reserve.days','可预订天数','2','NUMBER',0,1),
('reserve','鲜肉预订','reserve.cutoff_time','当日预订截止时间','18:00','STRING',0,2),
('reserve','鲜肉预订','reserve.split_fee_cube','切块加工费(元)','2.00','NUMBER',0,3),
('reserve','鲜肉预订','reserve.split_fee_minced','绞肉加工费(元)','2.00','NUMBER',0,4),
('reserve','鲜肉预订','reserve.split_fee_sliced','切片加工费(元)','3.00','NUMBER',0,5),
('reserve','鲜肉预订','reserve.loss_rate','分割损耗率(%)','3.00','NUMBER',0,6),

('sms','短信配置','sms.driver','短信服务商','aliyun','STRING',0,1),
('sms','短信配置','sms.sign','短信签名','猪事大吉','STRING',0,2),
('sms','短信配置','sms.access_key','AccessKey','','STRING',1,3),
('sms','短信配置','sms.access_secret','AccessSecret','','STRING',1,4),

('oss','对象存储','oss.driver','当前驱动','LOCAL','STRING',0,1),
('oss','对象存储','oss.url_prefix','访问域名前缀','','STRING',0,2);

-- =============================================================
-- 门店
-- =============================================================
DELETE FROM `store`;
INSERT INTO `store` (`id`,`code`,`name`,`contact`,`phone`,`province`,`city`,`district`,`address`,`lng`,`lat`,`business_hours`,`delivery_radius_km`,`delivery_fee`,`free_delivery_amount`,`min_order_amount`,`intro`,`status`,`sort`) VALUES
(1,'S001','猪事大吉·西城店','王店长','13800000001','北京市','北京市','西城区','西城区某某路 1 号',116.366000,39.912000,'07:00-21:00',3.00,5.00,59.00,20.00,'社区鲜肉旗舰店，含分割加工台',1,1),
(2,'S002','猪事大吉·朝阳店','孙店长','13800000009','北京市','北京市','朝阳区','朝阳区某某路 88 号',116.486000,39.921000,'07:30-21:30',5.00,6.00,69.00,20.00,'火锅食材专区',1,2);

-- =============================================================
-- 商品分类 / 商品
-- =============================================================
DELETE FROM `product_category`;
INSERT INTO `product_category` (`id`,`parent_id`,`name`,`name_en`,`biz_type`,`sort`,`status`) VALUES
(1,0,'鲜猪肉','Fresh Pork','PORK',1,1),
(2,0,'火锅食材','Hotpot Ingredients','HOTPOT',2,1),
(3,0,'肉制品','Processed Meat','PROCESSED',3,1),
(4,0,'火锅底料蘸料','Base & Sauce','BASE',4,1),
(5,0,'套餐礼盒','Combo & Gift','SET',5,1),
(101,1,'五花肉','Pork Belly','PORK',1,1),
(102,1,'里脊肉','Tenderloin','PORK',2,1),
(103,1,'排骨','Ribs','PORK',3,1),
(104,1,'分割肉','Cut Pork','PORK',4,1),
(201,2,'牛羊肉卷','Beef & Lamb Roll','HOTPOT',1,1),
(202,2,'丸类','Meatballs','HOTPOT',2,1),
(203,2,'豆制品','Bean Products','HOTPOT',3,1),
(204,2,'菌菇蔬菜','Mushroom & Veg','HOTPOT',4,1);

DELETE FROM `product`;
DELETE FROM `product_sku`;
INSERT INTO `product` (`id`,`category_id`,`name`,`sub_title`,`biz_type`,`unit`,`origin`,`shelf_life`,`storage_cond`,`cook_tip`,`reservable`,`split_enabled`,`split_fee`,`commission_rate`,`settle_type`,`tags`,`sales`,`sort`,`status`) VALUES
(1,101,'精品五花肉','当日冷链直供 肥瘦相间','PORK','斤','山东','冷藏 3 天','0-4℃ 冷藏','红烧/回锅/烤肉',1,1,2.00,5.00,'WEIGHT','热销',128,1,1),
(2,102,'鲜里脊肉','低脂高蛋白 适合儿童','PORK','斤','山东','冷藏 3 天','0-4℃ 冷藏','炒/炸/煎',1,1,2.00,5.00,'WEIGHT','新品',86,2,1),
(3,103,'肋排','炖汤首选','PORK','斤','河北','冷藏 3 天','0-4℃ 冷藏','炖汤/糖醋',1,1,2.00,5.00,'WEIGHT',NULL,64,3,1),
(4,104,'猪前腿肉(可分割)','免费分割 切块/绞肉/切片','PORK','斤','山东','冷藏 3 天','0-4℃ 冷藏','馅料/小炒',1,1,2.00,5.00,'WEIGHT',NULL,42,4,1),
(5,201,'肥牛卷','火锅必备 雪花纹理','HOTPOT','盒','内蒙古','冷冻 180 天','-18℃ 冷冻','涮煮 10 秒',0,0,0.00,8.00,'FIXED','热销',210,5,1),
(6,202,'牛肉丸','手打弹牙','HOTPOT','袋','广东','冷冻 180 天','-18℃ 冷冻','涮煮',0,0,0.00,8.00,'FIXED',NULL,150,6,1),
(7,3,'火腿肠礼盒','节日送礼 8 支装','PROCESSED','盒','河南','常温 90 天','常温阴凉','即食',0,0,0.00,10.00,'FIXED','礼盒',33,7,1),
(8,4,'牛油火锅底料','川味重辣','BASE','袋','四川','常温 365 天','常温阴凉','加水煮沸',0,0,0.00,10.00,'FIXED',NULL,120,8,1),
(9,5,'火锅到家套餐(3-4人)','肉卷+锅底+蘸料+丸类','SET','套','组合','冷藏 3 天','0-4℃ 冷藏','开箱即涮',0,0,0.00,6.00,'FIXED','套餐',58,9,1);

INSERT INTO `product_sku` (`id`,`product_id`,`sku_name`,`spec`,`price`,`market_price`,`cost_price`,`weight`,`unit`,`stock`,`stock_warn`,`status`) VALUES
(1,1,'五花肉 500g','500g/份',32.80,36.00,26.00,0.500,'份',200,20,1),
(2,1,'五花肉 1000g','1000g/份',62.00,72.00,52.00,1.000,'份',120,20,1),
(3,2,'里脊肉 500g','500g/份',29.80,33.00,23.50,0.500,'份',150,20,1),
(4,3,'肋排 500g','500g/份',38.80,42.00,30.00,0.500,'份',100,10,1),
(5,4,'前腿肉 500g','500g/份(可分割)',25.80,29.00,20.00,0.500,'份',180,20,1),
(6,5,'肥牛卷 300g','300g/盒',28.80,32.00,21.00,0.300,'盒',300,30,1),
(7,6,'牛肉丸 250g','250g/袋',19.90,23.00,14.00,0.250,'袋',260,30,1),
(8,7,'火腿肠礼盒 8支','8支/盒',59.00,69.00,42.00,0.800,'盒',80,10,1),
(9,8,'牛油底料 400g','400g/袋',16.80,19.90,11.00,0.400,'袋',400,40,1),
(10,9,'火锅到家套餐 3-4人','标准套',128.00,158.00,92.00,2.000,'套',60,10,1);

DELETE FROM `product_store`;
INSERT INTO `product_store` (`product_id`,`store_id`,`stock`,`status`)
SELECT p.`id`, s.`id`, 100, 1 FROM `product` p JOIN `store` s WHERE p.`deleted`=0;

-- 检疫资质示例
DELETE FROM `product_qualification`;
INSERT INTO `product_qualification` (`product_id`,`qual_type`,`qual_no`,`issuer`,`issue_date`,`expire_date`,`status`) VALUES
(1,'QUARANTINE','DWS-2026-0001','北京市动物卫生监督所','2026-01-01','2026-12-31',1),
(1,'QUALITY','PZ-2026-0001','北京市肉品品质检验中心','2026-01-01','2026-12-31',1),
(7,'SC','SC10241010001234','河南省市场监督管理局','2025-06-01','2028-05-31',1);

-- =============================================================
-- 会员 / 等级 / 券
-- =============================================================
DELETE FROM `member_level`;
INSERT INTO `member_level` (`id`,`name`,`level`,`upgrade_amount`,`discount`,`points_ratio`,`status`) VALUES
(1,'普通会员',1,0.00,100.00,1.00,1),
(2,'银卡会员',2,500.00,98.00,1.20,1),
(3,'金卡会员',3,2000.00,95.00,1.50,1);

DELETE FROM `member`;
INSERT INTO `member` (`id`,`unionid`,`openid`,`nickname`,`phone`,`level_id`,`balance`,`points`,`total_amount`,`default_store_id`,`status`) VALUES
(1,'oU_union_001','oM_open_001','张伟','13900000001',2,200.00,320,680.00,1,1),
(2,'oU_union_002','oM_open_002','李娜','13900000002',1,0.00,45,120.00,1,1),
(3,'oU_union_003','oM_open_003','王强','13900000003',3,500.00,1580,3200.00,2,1);

DELETE FROM `coupon`;
INSERT INTO `coupon` (`id`,`name`,`coupon_type`,`amount`,`discount`,`min_amount`,`total_count`,`received_count`,`per_limit`,`valid_type`,`valid_days`,`status`) VALUES
(1,'满 99 减 10',   'CASH',10.00,100.00,99.00,1000,12,1,'DAYS',30,1),
(2,'满 199 减 30',  'CASH',30.00,100.00,199.00,500,5,1,'DAYS',30,1),
(3,'鲜肉 95 折券',   'DISCOUNT',0.00,95.00,50.00,300,3,1,'DAYS',15,1),
(4,'火锅套餐免配送费','FREE_DELIVERY',0.00,100.00,0.00,200,1,1,'DAYS',7,1);

-- =============================================================
-- 供应商 / 渠道商 / 店员 示例
-- =============================================================
DELETE FROM `supplier`;
INSERT INTO `supplier` (`id`,`code`,`name`,`user_id`,`contact`,`phone`,`address`,`supply_type`,`settle_type`,`bank_name`,`bank_account`,`bank_holder`,`rating`,`status`) VALUES
(1,'GYS001','山东某某猪肉食品有限公司',7,'刘经理','13700000001','山东省临沂市某某路 9 号','PORK','MONTH','中国银行','6222000000000001','山东某某猪肉食品有限公司',4.8,1),
(2,'GYS002','内蒙古某某牛羊肉有限公司',NULL,'赵经理','13700000002','内蒙古呼和浩特市某某街 8 号','HOTPOT','MONTH','工商银行','6222000000000002','内蒙古某某牛羊肉有限公司',4.5,1);

DELETE FROM `supplier_qualification`;
INSERT INTO `supplier_qualification` (`supplier_id`,`qual_type`,`qual_no`,`issue_date`,`expire_date`,`audit_status`) VALUES
(1,'QUARANTINE','GYS-QT-2026-001','2026-01-01','2026-12-31','APPROVED'),
(1,'BUSINESS','9137000000000000XA','2020-03-01','2040-03-01','APPROVED'),
(2,'QUARANTINE','GYS-QT-2026-002','2026-02-01','2027-01-31','PENDING');

DELETE FROM `channel`;
INSERT INTO `channel` (`id`,`code`,`name`,`user_id`,`parent_id`,`level`,`channel_type`,`contact`,`phone`,`commission_rate`,`credit_limit`,`used_credit`,`status`) VALUES
(1,'QD001','某某社区团购团',8,0,1,'GROUP','陈团长','13600000001',8.00,50000.00,12000.00,1),
(2,'QD002','某某分销商',NULL,0,1,'DISTRIBUTOR','周经理','13600000002',10.00,30000.00,5000.00,1),
(3,'QD003','某某加盟店',NULL,0,1,'FRANCHISE','吴老板','13600000003',12.00,100000.00,30000.00,1);

DELETE FROM `channel_commission_rule`;
INSERT INTO `channel_commission_rule` (`name`,`channel_id`,`biz_type`,`level`,`rule_type`,`rate`,`fixed_amount`,`status`) VALUES
('全局默认佣金',NULL,NULL,1,'RATE',8.00,0.00,1),
('二级分销佣金',NULL,NULL,2,'RATE',3.00,0.00,1),
('鲜肉专项佣金',NULL,'PORK',1,'RATE',5.00,0.00,1),
('火锅食材佣金',NULL,'HOTPOT',1,'RATE',10.00,0.00,1);

DELETE FROM `staff`;
INSERT INTO `staff` (`id`,`user_id`,`store_id`,`name`,`phone`,`staff_type`,`commission_rate`,`status`) VALUES
(1,4,1,'张店员','13800000003','CLERK',2.00,1),
(2,5,1,'赵师傅','13800000004','CUTTER',3.00,1);

DELETE FROM `reserve_config`;
INSERT INTO `reserve_config` (`store_id`,`reserve_days`,`cutoff_time`,`split_fee_cube`,`split_fee_minced`,`split_fee_sliced`,`loss_rate`,`status`) VALUES
(1,2,'18:00',2.00,2.00,3.00,3.00,1),
(2,2,'18:00',2.00,2.00,3.00,3.00,1);

DELETE FROM `reserve_stock`;
INSERT INTO `reserve_stock` (`store_id`,`product_id`,`sku_id`,`reserve_date`,`capacity`,`booked`,`version`) VALUES
(1,1,1,CURDATE(),100,12,0),
(1,2,3,CURDATE(),80,6,0),
(1,4,5,CURDATE(),120,20,0);

-- =============================================================
-- 官网 CMS 示例
-- =============================================================
DELETE FROM `cms_category`;
INSERT INTO `cms_category` (`id`,`name`,`name_en`,`code`,`sort`,`status`) VALUES
(1,'品牌动态','Brand News','news',1,1),
(2,'行业资讯','Industry','industry',2,1),
(3,'客户案例','Cases','case',3,1);

DELETE FROM `cms_article`;
INSERT INTO `cms_article` (`id`,`category_id`,`title`,`title_en`,`summary`,`content`,`article_type`,`is_top`,`status`,`publish_time`) VALUES
(1,1,'猪事大吉：把鲜肉铺搬进社区','ZhuShi DaJi: Fresh Meat in Community','诸事大吉的谐音，做社区一站式鲜肉与火锅食材超市','<p>猪事大吉，取“诸事大吉”谐音，专注社区鲜肉、火锅食材与肉制品。</p>','BRAND',1,1,NOW()),
(2,1,'为什么选择当日冷鲜猪肉','Why Daily Chilled Pork','两证两章，全程冷链','<p>每一批猪肉均附动物产品检疫合格证明与肉品品质检验合格证。</p>','NEWS',0,1,NOW()),
(3,3,'某社区团购合作案例','Community Group Buy Case','月均团购 3 万单','<p>通过渠道商报单与结算闭环，实现高效分销。</p>','CASE',0,1,NOW());

DELETE FROM `cms_banner`;
INSERT INTO `cms_banner` (`title`,`title_en`,`image`,`link_url`,`position`,`sort`,`status`) VALUES
('猪事大吉 · 社区鲜肉','ZhuShi DaJi Fresh Meat','/static/banner1.jpg','/products','PC_HOME',1,1),
('火锅到家 · 一站备齐','Hotpot to Home','/static/banner2.jpg','/products','PC_HOME',2,1),
('猪事大吉','ZhuShi DaJi','/static/mini-banner1.jpg','/pages/reserve/index','MINIAPP_HOME',1,1);

-- =============================================================
-- 微信模板消息配置
-- =============================================================
DELETE FROM `wechat_template`;
INSERT INTO `wechat_template` (`biz_type`,`template_id`,`title`,`status`) VALUES
('ORDER_PAID','','订单支付成功通知',1),
('ORDER_PREPARING','','订单备货中通知',1),
('ORDER_READY','','订单可自提通知',1),
('ORDER_DELIVERING','','订单配送中通知',1),
('ACTIVITY','','活动通知',1);

-- =============================================================
-- 对象存储默认配置（LOCAL）
-- =============================================================
DELETE FROM `oss_config`;
INSERT INTO `oss_config` (`driver`,`config_json`,`is_default`,`status`) VALUES
('LOCAL','{"uploadPath":"./uploads","urlPrefix":"/uploads"}',1,1);

-- =============================================================
-- 示例订单（便于看板与后台联调）
-- =============================================================
DELETE FROM `order_info`;
DELETE FROM `order_item`;
INSERT INTO `order_info` (`id`,`order_no`,`member_id`,`store_id`,`order_type`,`source`,`status`,`delivery_type`,`appoint_date`,`receiver_name`,`receiver_phone`,`receiver_address`,`total_amount`,`split_fee`,`delivery_fee`,`discount_amount`,`pay_amount`,`cost_amount`,`pay_status`,`pay_type`,`pay_time`,`create_time`) VALUES
(1,'ZS202610160001',1,1,'RESERVE','MINIAPP','PREPARING','SELF_PICKUP',CURDATE(),'张伟','13900000001',NULL,97.60,2.00,0.00,10.00,89.60,78.00,'PAID','WECHAT',NOW(),NOW()),
(2,'ZS202610160002',2,1,'NORMAL','MINIAPP','READY','DELIVERY',NULL,'李娜','13900000002','西城区某某小区 3 号楼',48.70,0.00,5.00,0.00,53.70,35.00,'PAID','WECHAT',NOW(),NOW()),
(3,'ZS202610160003',3,2,'SET','H5','COMPLETED','SELF_PICKUP',NULL,'王强','13900000003',NULL,128.00,0.00,0.00,0.00,128.00,92.00,'PAID','WECHAT',NOW(),NOW()),
(4,'ZS202610160004',1,1,'GIFT','MINIAPP','UNPAID','DELIVERY',NULL,'张伟','13900000001','西城区某某小区',59.00,0.00,5.00,0.00,64.00,42.00,'UNPAID',NULL,NULL,NOW());

INSERT INTO `order_item` (`order_id`,`order_no`,`product_id`,`sku_id`,`product_name`,`sku_name`,`price`,`quantity`,`weight`,`amount`,`split_type`,`split_fee`) VALUES
(1,'ZS202610160001',1,1,'精品五花肉','五花肉 500g',32.80,2,1.000,65.60,'CUBE',2.00),
(1,'ZS202610160001',3,4,'肋排','肋排 500g',32.00,1,0.500,32.00,NULL,0.00),
(2,'ZS202610160002',5,6,'肥牛卷','肥牛卷 300g',28.80,1,0.300,28.80,NULL,0.00),
(2,'ZS202610160002',6,7,'牛肉丸','牛肉丸 250g',19.90,1,0.250,19.90,NULL,0.00),
(3,'ZS202610160003',9,10,'火锅到家套餐(3-4人)','标准套',128.00,1,2.000,128.00,NULL,0.00),
(4,'ZS202610160004',7,8,'火腿肠礼盒','火腿肠礼盒 8支',59.00,1,0.800,59.00,NULL,0.00);

DELETE FROM `order_log`;
INSERT INTO `order_log` (`order_id`,`order_no`,`from_status`,`to_status`,`operator`,`remark`) VALUES
(1,'ZS202610160001','UNPAID','PREPARING','system','支付成功'),
(2,'ZS202610160002','UNPAID','READY','store01','已备货待取货'),
(3,'ZS202610160003','DELIVERING','COMPLETED','system','确认收货');
