-- =============================================================
-- 猪事大吉 · 多端数字化平台  —— 数据库建表脚本
-- MySQL 8 / utf8mb4 / InnoDB
-- 约定：所有表含 id(PK) / create_time / update_time / deleted(软删除)
-- =============================================================

CREATE DATABASE IF NOT EXISTS `zhushu`
  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `zhushu`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================
-- 一、系统：RBAC / 菜单 / 参数 / 字典 / 多语言 / 审计
-- =============================================================

DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username`    VARCHAR(64)  NOT NULL COMMENT '登录账号',
  `password`    VARCHAR(100) NOT NULL COMMENT 'BCrypt 密码',
  `nickname`    VARCHAR(64)           DEFAULT NULL COMMENT '昵称',
  `real_name`   VARCHAR(64)           DEFAULT NULL COMMENT '真实姓名',
  `phone`       VARCHAR(20)           DEFAULT NULL COMMENT '手机号',
  `email`       VARCHAR(100)          DEFAULT NULL COMMENT '邮箱',
  `avatar`      VARCHAR(255)          DEFAULT NULL COMMENT '头像',
  `user_type`   VARCHAR(20)  NOT NULL DEFAULT 'ADMIN' COMMENT 'ADMIN/STORE_MANAGER/FINANCE/CLERK/CUTTER/CUSTOMER/SERVICE/SUPPLIER/CHANNEL',
  `store_id`    BIGINT                DEFAULT NULL COMMENT '所属门店(店员/店长)',
  `is_super`    TINYINT      NOT NULL DEFAULT 0 COMMENT '是否超级管理员 1=是(拥有全量维护权限)',
  `status`      TINYINT      NOT NULL DEFAULT 1 COMMENT '状态 1=启用 0=禁用',
  `last_login_time` DATETIME          DEFAULT NULL COMMENT '最近登录时间',
  `last_login_ip`   VARCHAR(64)       DEFAULT NULL COMMENT '最近登录IP',
  `remark`      VARCHAR(255)          DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='后台/端用户表';

DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `code`        VARCHAR(64)  NOT NULL COMMENT '角色编码',
  `name`        VARCHAR(64)  NOT NULL COMMENT '角色名称',
  `platform`    VARCHAR(20)  NOT NULL DEFAULT 'ADMIN' COMMENT 'ADMIN/CUSTOMER/SUPPLIER/CHANNEL/STAFF',
  `data_scope`  VARCHAR(20)  NOT NULL DEFAULT 'SELF' COMMENT 'ALL/STORE/SELF',
  `sort`        INT          NOT NULL DEFAULT 0,
  `status`      TINYINT      NOT NULL DEFAULT 1,
  `remark`      VARCHAR(255)          DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `parent_id`   BIGINT       NOT NULL DEFAULT 0 COMMENT '父级ID',
  `platform`    VARCHAR(20)  NOT NULL DEFAULT 'ADMIN' COMMENT '平台 ADMIN/PC/WECHAT/MINIAPP/H5',
  `menu_type`   VARCHAR(20)  NOT NULL DEFAULT 'MENU' COMMENT 'DIR目录/MENU菜单/BUTTON按钮/LINK外链',
  `name`        VARCHAR(64)  NOT NULL COMMENT '菜单名称',
  `name_en`     VARCHAR(64)           DEFAULT NULL COMMENT '英文名称(i18n)',
  `path`        VARCHAR(128)          DEFAULT NULL COMMENT '路由地址/链接',
  `component`   VARCHAR(128)          DEFAULT NULL COMMENT '组件路径',
  `icon`        VARCHAR(64)           DEFAULT NULL COMMENT '图标',
  `perm`        VARCHAR(128)          DEFAULT NULL COMMENT '权限标识 product:sku:list',
  `link_url`    VARCHAR(255)          DEFAULT NULL COMMENT '外链 URL',
  `link_type`   VARCHAR(20)           DEFAULT NULL COMMENT 'PAGE/PAGEVIEW/MINIAPP/WEBVIEW 公众号菜单类型',
  `appid`       VARCHAR(64)           DEFAULT NULL COMMENT '公众号菜单跳转 appid',
  `page_path`   VARCHAR(255)          DEFAULT NULL COMMENT '小程序页面路径',
  `sort`        INT          NOT NULL DEFAULT 0 COMMENT '排序(拖拽维护)',
  `visible`     TINYINT      NOT NULL DEFAULT 1 COMMENT '是否显示',
  `keep_alive`  TINYINT      NOT NULL DEFAULT 1 COMMENT '是否缓存',
  `status`      TINYINT      NOT NULL DEFAULT 1,
  `remark`      VARCHAR(255)          DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_platform` (`platform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单表(后台/官网/公众号/小程序 tabBar/H5 五套,可增删改+拖拽排序)';

DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id`      BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `role_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联';

DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `id`      BIGINT NOT NULL AUTO_INCREMENT,
  `role_id` BIGINT NOT NULL,
  `menu_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_menu` (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色菜单关联';

DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT,
  `group_code`   VARCHAR(64)  NOT NULL COMMENT '分组 site/icp/service/wechat/pay/oss/delivery/commission/reserve',
  `group_name`   VARCHAR(64)           DEFAULT NULL COMMENT '分组名称',
  `config_key`   VARCHAR(128) NOT NULL COMMENT '参数键',
  `config_name`  VARCHAR(128) NOT NULL COMMENT '参数名',
  `config_value` TEXT                  DEFAULT NULL COMMENT '参数值',
  `value_type`   VARCHAR(20)  NOT NULL DEFAULT 'STRING' COMMENT 'STRING/NUMBER/BOOLEAN/JSON/IMAGE/TEXT',
  `encrypted`    TINYINT      NOT NULL DEFAULT 0 COMMENT '是否加密存储',
  `sort`         INT          NOT NULL DEFAULT 0,
  `remark`       VARCHAR(255)          DEFAULT NULL,
  `create_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`      TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统参数(可视化配置)';

DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `code`        VARCHAR(64)  NOT NULL COMMENT '字典编码',
  `name`        VARCHAR(64)  NOT NULL COMMENT '字典名称',
  `sort`        INT          NOT NULL DEFAULT 0,
  `status`      TINYINT      NOT NULL DEFAULT 1,
  `remark`      VARCHAR(255)          DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dict_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典类型';

DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `dict_code`   VARCHAR(64)  NOT NULL COMMENT '字典编码',
  `label`       VARCHAR(64)  NOT NULL COMMENT '显示值',
  `label_en`    VARCHAR(64)           DEFAULT NULL COMMENT '英文显示值',
  `value`       VARCHAR(64)  NOT NULL COMMENT '数据值',
  `sort`        INT          NOT NULL DEFAULT 0,
  `status`      TINYINT      NOT NULL DEFAULT 1,
  `remark`      VARCHAR(255)          DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_dict_code` (`dict_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典数据';

DROP TABLE IF EXISTS `sys_lang`;
CREATE TABLE `sys_lang` (
  `id`          BIGINT      NOT NULL AUTO_INCREMENT,
  `code`        VARCHAR(20) NOT NULL COMMENT '语言编码 zh-CN/en-US',
  `name`        VARCHAR(32) NOT NULL,
  `is_default`  TINYINT     NOT NULL DEFAULT 0,
  `status`      TINYINT     NOT NULL DEFAULT 1,
  `sort`        INT         NOT NULL DEFAULT 0,
  `create_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT     NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_lang_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='语言维护';

DROP TABLE IF EXISTS `sys_i18n`;
CREATE TABLE `sys_i18n` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `lang_code`   VARCHAR(20)  NOT NULL,
  `module`      VARCHAR(32)  NOT NULL DEFAULT 'common' COMMENT '模块',
  `i18n_key`    VARCHAR(128) NOT NULL COMMENT '词条 key',
  `i18n_value`  TEXT                  DEFAULT NULL COMMENT '词条值',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_lang_key` (`lang_code`,`module`,`i18n_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='多语言词条';

DROP TABLE IF EXISTS `sys_audit_log`;
CREATE TABLE `sys_audit_log` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `user_id`     BIGINT                DEFAULT NULL,
  `username`    VARCHAR(64)           DEFAULT NULL,
  `module`      VARCHAR(64)           DEFAULT NULL COMMENT '模块',
  `action`      VARCHAR(64)           DEFAULT NULL COMMENT '操作类型',
  `method`      VARCHAR(10)           DEFAULT NULL,
  `uri`         VARCHAR(255)          DEFAULT NULL,
  `params`      TEXT                  DEFAULT NULL,
  `result`      TEXT                  DEFAULT NULL,
  `ip`          VARCHAR(64)           DEFAULT NULL,
  `ua`          VARCHAR(500)          DEFAULT NULL,
  `cost_ms`     BIGINT                DEFAULT NULL,
  `status`      TINYINT      NOT NULL DEFAULT 1 COMMENT '1成功 0失败',
  `error_msg`   TEXT                  DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审计日志(仅查询,不可增删改)';

-- =============================================================
-- 二、门店
-- =============================================================

DROP TABLE IF EXISTS `store`;
CREATE TABLE `store` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `code`           VARCHAR(64)  NOT NULL COMMENT '门店编码',
  `name`           VARCHAR(128) NOT NULL COMMENT '门店名称',
  `manager_id`     BIGINT                DEFAULT NULL COMMENT '店长用户ID',
  `contact`        VARCHAR(64)           DEFAULT NULL COMMENT '联系人',
  `phone`          VARCHAR(20)           DEFAULT NULL COMMENT '联系电话',
  `province`       VARCHAR(64)           DEFAULT NULL,
  `city`           VARCHAR(64)           DEFAULT NULL,
  `district`       VARCHAR(64)           DEFAULT NULL,
  `address`        VARCHAR(255)          DEFAULT NULL COMMENT '详细地址',
  `lng`            DECIMAL(10,6)         DEFAULT NULL COMMENT '经度',
  `lat`            DECIMAL(10,6)         DEFAULT NULL COMMENT '纬度',
  `business_hours` VARCHAR(64)           DEFAULT NULL COMMENT '营业时间 08:00-21:00',
  `delivery_radius_km` DECIMAL(6,2)      DEFAULT 3.00 COMMENT '配送半径(km)',
  `delivery_fee`   DECIMAL(10,2)         DEFAULT 0.00 COMMENT '配送费',
  `free_delivery_amount` DECIMAL(10,2)   DEFAULT 0.00 COMMENT '满额免配送费',
  `min_order_amount`     DECIMAL(10,2)   DEFAULT 0.00 COMMENT '起送金额',
  `images`         VARCHAR(1000)         DEFAULT NULL COMMENT '门店图片(逗号分隔)',
  `intro`          VARCHAR(500)          DEFAULT NULL COMMENT '门店简介',
  `status`         TINYINT      NOT NULL DEFAULT 1 COMMENT '1营业 0停业',
  `sort`           INT          NOT NULL DEFAULT 0,
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_store_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='门店(多门店)';

-- =============================================================
-- 三、商品：分类 / 商品 / SKU / 门店可售 / 检疫资质
-- =============================================================

DROP TABLE IF EXISTS `product_category`;
CREATE TABLE `product_category` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `parent_id`   BIGINT       NOT NULL DEFAULT 0,
  `name`        VARCHAR(64)  NOT NULL,
  `name_en`     VARCHAR(64)           DEFAULT NULL,
  `biz_type`    VARCHAR(20)  NOT NULL DEFAULT 'PORK' COMMENT 'PORK鲜猪肉/HOTPOT火锅食材/PROCESSED肉制品/BASE火锅底料蘸料/SET套餐礼盒',
  `icon`        VARCHAR(255)          DEFAULT NULL,
  `sort`        INT          NOT NULL DEFAULT 0,
  `status`      TINYINT      NOT NULL DEFAULT 1,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类';

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `category_id`    BIGINT       NOT NULL,
  `name`           VARCHAR(128) NOT NULL,
  `sub_title`      VARCHAR(255)          DEFAULT NULL COMMENT '副标题',
  `biz_type`       VARCHAR(20)  NOT NULL DEFAULT 'PORK' COMMENT 'PORK/HOTPOT/PROCESSED/BASE/SET',
  `cover`          VARCHAR(255)          DEFAULT NULL,
  `images`         VARCHAR(1000)         DEFAULT NULL COMMENT '轮播图',
  `detail`         LONGTEXT              DEFAULT NULL COMMENT '富文本详情(WangEditor)',
  `unit`           VARCHAR(16)           DEFAULT '斤' COMMENT '单位',
  `origin`         VARCHAR(128)          DEFAULT NULL COMMENT '产地',
  `shelf_life`     VARCHAR(64)           DEFAULT NULL COMMENT '保质期',
  `storage_cond`   VARCHAR(128)          DEFAULT NULL COMMENT '储存条件(冷链/冷藏)',
  `cook_tip`       VARCHAR(500)          DEFAULT NULL COMMENT '食用/烹饪提示',
  `reservable`     TINYINT      NOT NULL DEFAULT 0 COMMENT '是否支持鲜肉预订',
  `split_enabled`  TINYINT      NOT NULL DEFAULT 0 COMMENT '是否支持分割选项(切块/绞肉/切片)',
  `split_fee`      DECIMAL(10,2)         DEFAULT 0.00 COMMENT '分割加工费',
  `commission_rate` DECIMAL(6,2)         DEFAULT 0.00 COMMENT '分销佣金比例(%)',
  `settle_type`    VARCHAR(20)           DEFAULT 'WEIGHT' COMMENT '结算方式 WEIGHT/FIXED',
  `tags`           VARCHAR(255)          DEFAULT NULL COMMENT '标签(热销/新品)',
  `sales`          INT          NOT NULL DEFAULT 0 COMMENT '销量',
  `sort`           INT          NOT NULL DEFAULT 0,
  `status`         TINYINT      NOT NULL DEFAULT 0 COMMENT '0待审核 1上架 2下架',
  `audit_remark`   VARCHAR(255)          DEFAULT NULL COMMENT '审核备注',
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_biz_type` (`biz_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品';

DROP TABLE IF EXISTS `product_sku`;
CREATE TABLE `product_sku` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT,
  `product_id`   BIGINT       NOT NULL,
  `sku_name`     VARCHAR(128) NOT NULL COMMENT '规格名 如 五花肉 500g',
  `spec`         VARCHAR(128)          DEFAULT NULL COMMENT '规格描述',
  `barcode`      VARCHAR(64)           DEFAULT NULL,
  `price`        DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '售价',
  `market_price` DECIMAL(10,2)         DEFAULT 0.00 COMMENT '划线价',
  `cost_price`   DECIMAL(10,2)         DEFAULT 0.00 COMMENT '成本价',
  `weight`       DECIMAL(10,3)         DEFAULT 0.000 COMMENT '规格重量(kg)',
  `unit`         VARCHAR(16)           DEFAULT '份',
  `stock`        INT          NOT NULL DEFAULT 0 COMMENT '总库存',
  `stock_warn`   INT          NOT NULL DEFAULT 0 COMMENT '库存预警值',
  `status`       TINYINT      NOT NULL DEFAULT 1,
  `create_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`      TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品规格';

DROP TABLE IF EXISTS `product_store`;
CREATE TABLE `product_store` (
  `id`          BIGINT  NOT NULL AUTO_INCREMENT,
  `product_id`  BIGINT  NOT NULL,
  `store_id`    BIGINT  NOT NULL,
  `stock`       INT     NOT NULL DEFAULT 0 COMMENT '该门店库存',
  `status`      TINYINT NOT NULL DEFAULT 1 COMMENT '可售状态',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_store` (`product_id`,`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品-门店可售与库存';

DROP TABLE IF EXISTS `product_qualification`;
CREATE TABLE `product_qualification` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `product_id`  BIGINT       NOT NULL,
  `qual_type`   VARCHAR(20)  NOT NULL COMMENT 'QUARANTINE动物检疫合格证明/QUALITY肉品品质检验合格证/SC食品生产许可/INSPECTION检测报告',
  `qual_no`     VARCHAR(128)          DEFAULT NULL COMMENT '证书编号',
  `issuer`      VARCHAR(128)          DEFAULT NULL COMMENT '发证机构',
  `issue_date`  DATE                  DEFAULT NULL,
  `expire_date` DATE                  DEFAULT NULL,
  `file_url`    VARCHAR(500)          DEFAULT NULL COMMENT '证明文件',
  `status`      TINYINT      NOT NULL DEFAULT 1 COMMENT '1有效 0失效',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品检疫/资质证明(猪肉两证两章、SC)';

-- =============================================================
-- 四、会员营销：会员 / 等级 / 储值 / 积分 / 优惠券
-- =============================================================

DROP TABLE IF EXISTS `member_level`;
CREATE TABLE `member_level` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `name`          VARCHAR(64)  NOT NULL COMMENT '等级名称',
  `level`         INT          NOT NULL DEFAULT 1,
  `upgrade_amount` DECIMAL(10,2) DEFAULT 0.00 COMMENT '升级所需累计消费',
  `discount`      DECIMAL(5,2) DEFAULT 100.00 COMMENT '折扣(百分数 95=95折)',
  `points_ratio`  DECIMAL(6,2) DEFAULT 1.00 COMMENT '积分倍率',
  `icon`          VARCHAR(255)          DEFAULT NULL,
  `status`        TINYINT      NOT NULL DEFAULT 1,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员等级';

DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `unionid`       VARCHAR(64)           DEFAULT NULL COMMENT '微信 UnionID',
  `openid`        VARCHAR(64)           DEFAULT NULL COMMENT '小程序 openid',
  `mp_openid`     VARCHAR(64)           DEFAULT NULL COMMENT '公众号 openid',
  `nickname`      VARCHAR(64)           DEFAULT NULL,
  `avatar`        VARCHAR(500)          DEFAULT NULL,
  `phone`         VARCHAR(20)           DEFAULT NULL,
  `gender`        TINYINT               DEFAULT 0,
  `level_id`      BIGINT                DEFAULT NULL COMMENT '会员等级',
  `balance`       DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '储值余额',
  `points`        INT          NOT NULL DEFAULT 0 COMMENT '积分',
  `total_amount`  DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '累计消费',
  `default_store_id` BIGINT             DEFAULT NULL COMMENT '常用门店',
  `status`        TINYINT      NOT NULL DEFAULT 1 COMMENT '1正常 0禁用',
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_unionid` (`unionid`),
  KEY `idx_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员';

DROP TABLE IF EXISTS `member_balance_log`;
CREATE TABLE `member_balance_log` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `member_id`   BIGINT       NOT NULL,
  `change_type` VARCHAR(20)  NOT NULL COMMENT 'RECHARGE充值/CONSUME消费/REFUND退款/ADJUST调整',
  `amount`      DECIMAL(12,2) NOT NULL COMMENT '变动金额(正增负减)',
  `balance`     DECIMAL(12,2) NOT NULL COMMENT '变动后余额',
  `biz_no`      VARCHAR(64)           DEFAULT NULL COMMENT '关联单号',
  `remark`      VARCHAR(255)          DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='储值流水';

DROP TABLE IF EXISTS `member_points_log`;
CREATE TABLE `member_points_log` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `member_id`   BIGINT       NOT NULL,
  `change_type` VARCHAR(20)  NOT NULL COMMENT 'EARN获得/USE使用/REFUND退回/ADJUST调整',
  `points`      INT          NOT NULL COMMENT '变动积分',
  `balance`     INT          NOT NULL COMMENT '变动后积分',
  `biz_no`      VARCHAR(64)           DEFAULT NULL,
  `remark`      VARCHAR(255)          DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分流水';

DROP TABLE IF EXISTS `coupon`;
CREATE TABLE `coupon` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `name`           VARCHAR(128) NOT NULL,
  `coupon_type`    VARCHAR(20)  NOT NULL DEFAULT 'CASH' COMMENT 'CASH满减/DISCOUNT折扣/FREE_DELIVERY免配送费',
  `amount`         DECIMAL(10,2) DEFAULT 0.00 COMMENT '面额',
  `discount`       DECIMAL(5,2)  DEFAULT 100.00 COMMENT '折扣',
  `min_amount`     DECIMAL(10,2) DEFAULT 0.00 COMMENT '使用门槛',
  `total_count`    INT          NOT NULL DEFAULT 0 COMMENT '发放总量',
  `received_count` INT          NOT NULL DEFAULT 0 COMMENT '已领取',
  `per_limit`      INT          NOT NULL DEFAULT 1 COMMENT '每人限领',
  `scope_store`    VARCHAR(255)          DEFAULT NULL COMMENT '适用门店(逗号),空=全部',
  `scope_biz_type` VARCHAR(128)          DEFAULT NULL COMMENT '适用品类',
  `valid_type`     VARCHAR(20)  NOT NULL DEFAULT 'FIXED' COMMENT 'FIXED固定日期/DAYS领取后N天',
  `valid_days`     INT                   DEFAULT NULL,
  `start_time`     DATETIME              DEFAULT NULL,
  `end_time`       DATETIME              DEFAULT NULL,
  `status`         TINYINT      NOT NULL DEFAULT 1 COMMENT '1上架 0下架',
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券';

DROP TABLE IF EXISTS `member_coupon`;
CREATE TABLE `member_coupon` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `coupon_id`   BIGINT       NOT NULL,
  `member_id`   BIGINT       NOT NULL,
  `code`        VARCHAR(64)           DEFAULT NULL COMMENT '券码',
  `status`      VARCHAR(20)  NOT NULL DEFAULT 'UNUSED' COMMENT 'UNUSED/USED/EXPIRED',
  `order_id`    BIGINT                DEFAULT NULL COMMENT '使用订单',
  `use_time`    DATETIME              DEFAULT NULL,
  `expire_time` DATETIME              DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员优惠券';

-- =============================================================
-- 五、订单：订单 / 明细 / 日志 / 售后
-- =============================================================

DROP TABLE IF EXISTS `order_info`;
CREATE TABLE `order_info` (
  `id`              BIGINT       NOT NULL AUTO_INCREMENT,
  `order_no`        VARCHAR(64)  NOT NULL COMMENT '订单号',
  `member_id`       BIGINT       NOT NULL,
  `store_id`        BIGINT       NOT NULL,
  `order_type`      VARCHAR(20)  NOT NULL DEFAULT 'NORMAL' COMMENT 'NORMAL普通/RESERVE鲜肉预订/SET火锅套餐/GIFT礼盒',
  `source`          VARCHAR(20)  NOT NULL DEFAULT 'MINIAPP' COMMENT 'MINIAPP/H5/PC/STAFF/CHANNEL',
  `status`          VARCHAR(20)  NOT NULL DEFAULT 'UNPAID' COMMENT 'UNPAID待支付/PREPARING待备货/READY待取货/DELIVERING配送中/COMPLETED已完成/CANCELLED已取消/AFTERSALE售后',
  `delivery_type`   VARCHAR(20)  NOT NULL DEFAULT 'SELF_PICKUP' COMMENT 'SELF_PICKUP自提/DELIVERY配送',
  `appoint_date`    DATE                  DEFAULT NULL COMMENT '预订/取货日期',
  `appoint_slot`    VARCHAR(32)           DEFAULT NULL COMMENT '时间段',
  `receiver_name`   VARCHAR(64)           DEFAULT NULL,
  `receiver_phone`  VARCHAR(20)           DEFAULT NULL,
  `receiver_address` VARCHAR(255)         DEFAULT NULL,
  `total_amount`    DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '商品总额',
  `split_fee`       DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '分割加工费',
  `delivery_fee`    DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '配送费',
  `discount_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '优惠金额',
  `pay_amount`      DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '实付金额',
  `cost_amount`     DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '成本金额(损耗核算)',
  `pay_status`      VARCHAR(20)  NOT NULL DEFAULT 'UNPAID' COMMENT 'UNPAID/PAID/REFUNDED/PART_REFUND',
  `pay_type`        VARCHAR(20)           DEFAULT NULL COMMENT 'WECHAT/BALANCE/CASH',
  `pay_time`        DATETIME              DEFAULT NULL,
  `channel_id`      BIGINT                DEFAULT NULL COMMENT '渠道商ID',
  `staff_id`        BIGINT                DEFAULT NULL COMMENT '开单店员',
  `remark`          VARCHAR(500)          DEFAULT NULL COMMENT '买家备注',
  `cancel_reason`   VARCHAR(255)          DEFAULT NULL,
  `finish_time`     DATETIME              DEFAULT NULL,
  `expire_time`     DATETIME              DEFAULT NULL COMMENT '支付超时时间',
  `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`         TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_member` (`member_id`),
  KEY `idx_store` (`store_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单';

DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `order_id`    BIGINT       NOT NULL,
  `order_no`    VARCHAR(64)  NOT NULL,
  `product_id`  BIGINT       NOT NULL,
  `sku_id`      BIGINT                DEFAULT NULL,
  `product_name` VARCHAR(128) NOT NULL,
  `sku_name`    VARCHAR(128)          DEFAULT NULL,
  `cover`       VARCHAR(255)          DEFAULT NULL,
  `price`       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `quantity`    INT          NOT NULL DEFAULT 1,
  `weight`      DECIMAL(10,3)         DEFAULT 0.000 COMMENT '预估重量(kg)',
  `actual_weight` DECIMAL(10,3)       DEFAULT NULL COMMENT '实称重量(kg)',
  `amount`      DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `split_type`  VARCHAR(20)           DEFAULT NULL COMMENT '分割选项 CUBE切块/MINCED绞肉/SLICED切片',
  `split_fee`   DECIMAL(10,2)         DEFAULT 0.00,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细';

DROP TABLE IF EXISTS `order_log`;
CREATE TABLE `order_log` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `order_id`    BIGINT       NOT NULL,
  `order_no`    VARCHAR(64)           DEFAULT NULL,
  `from_status` VARCHAR(20)           DEFAULT NULL,
  `to_status`   VARCHAR(20)           DEFAULT NULL,
  `operator`    VARCHAR(64)           DEFAULT NULL,
  `remark`      VARCHAR(255)          DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单状态日志';

DROP TABLE IF EXISTS `order_aftersale`;
CREATE TABLE `order_aftersale` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT,
  `aftersale_no` VARCHAR(64)  NOT NULL,
  `order_id`     BIGINT       NOT NULL,
  `order_no`     VARCHAR(64)           DEFAULT NULL,
  `member_id`    BIGINT                DEFAULT NULL,
  `aftersale_type` VARCHAR(20) NOT NULL DEFAULT 'REFUND' COMMENT 'REFUND退款/RETURN退货/EXCHANGE换货',
  `reason`       VARCHAR(255)          DEFAULT NULL,
  `images`       VARCHAR(1000)         DEFAULT NULL,
  `amount`       DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `status`       VARCHAR(20)  NOT NULL DEFAULT 'APPLYING' COMMENT 'APPLYING待审核/AGREED已同意/REJECTED已拒绝/DONE已完成',
  `audit_remark` VARCHAR(255)          DEFAULT NULL,
  `audit_time`   DATETIME              DEFAULT NULL,
  `create_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`      TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单售后';

-- =============================================================
-- 六、鲜肉预订：备货量 / 预订配置
-- =============================================================

DROP TABLE IF EXISTS `reserve_stock`;
CREATE TABLE `reserve_stock` (
  `id`           BIGINT  NOT NULL AUTO_INCREMENT,
  `store_id`     BIGINT  NOT NULL,
  `product_id`   BIGINT  NOT NULL,
  `sku_id`       BIGINT           DEFAULT NULL,
  `reserve_date` DATE    NOT NULL COMMENT '预订日期',
  `capacity`     INT     NOT NULL DEFAULT 0 COMMENT '备货量(份/斤)',
  `booked`       INT     NOT NULL DEFAULT 0 COMMENT '已预订量',
  `version`      INT     NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `create_time`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`      TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_store_prod_date` (`store_id`,`product_id`,`sku_id`,`reserve_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='鲜肉预订备货量(Redis锁防超卖)';

DROP TABLE IF EXISTS `reserve_config`;
CREATE TABLE `reserve_config` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `store_id`      BIGINT       NOT NULL,
  `reserve_days`  INT          NOT NULL DEFAULT 2 COMMENT '可预订天数(当天/次日)',
  `cutoff_time`   VARCHAR(16)           DEFAULT '18:00' COMMENT '当日预订截止时间',
  `split_fee_cube`   DECIMAL(10,2) DEFAULT 0.00 COMMENT '切块加工费',
  `split_fee_minced` DECIMAL(10,2) DEFAULT 0.00 COMMENT '绞肉加工费',
  `split_fee_sliced` DECIMAL(10,2) DEFAULT 0.00 COMMENT '切片加工费',
  `loss_rate`     DECIMAL(6,2) DEFAULT 3.00 COMMENT '分割损耗率(%)',
  `status`        TINYINT      NOT NULL DEFAULT 1,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_store` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='鲜肉预订配置(分割加工费/损耗率可配)';

-- =============================================================
-- 七、供应商：档案 / 协议 / 资质 / 采购 / 供货 / 对账结算 / 库存预警
-- =============================================================

DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT,
  `code`         VARCHAR(64)  NOT NULL COMMENT '供应商编码',
  `name`         VARCHAR(128) NOT NULL,
  `user_id`      BIGINT                DEFAULT NULL COMMENT '供应商端登录账号',
  `contact`      VARCHAR(64)           DEFAULT NULL,
  `phone`        VARCHAR(20)           DEFAULT NULL,
  `address`      VARCHAR(255)          DEFAULT NULL,
  `supply_type`  VARCHAR(20)  NOT NULL DEFAULT 'PORK' COMMENT 'PORK猪肉/HOTPOT火锅食材/PROCESSED肉制品/BASE底料',
  `settle_type`  VARCHAR(20)  NOT NULL DEFAULT 'MONTH' COMMENT 'MONTH月结/WEEK周结/CASH现结',
  `bank_name`    VARCHAR(128)          DEFAULT NULL,
  `bank_account` VARCHAR(64)           DEFAULT NULL,
  `bank_holder`  VARCHAR(64)           DEFAULT NULL,
  `rating`       DECIMAL(3,1)          DEFAULT 5.0 COMMENT '评级(1-5)',
  `status`       TINYINT      NOT NULL DEFAULT 1 COMMENT '1合作 0停用',
  `remark`       VARCHAR(255)          DEFAULT NULL,
  `create_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`      TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_supplier_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商档案';

DROP TABLE IF EXISTS `supplier_agreement`;
CREATE TABLE `supplier_agreement` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `supplier_id`    BIGINT       NOT NULL,
  `agreement_no`   VARCHAR(64)           DEFAULT NULL,
  `title`          VARCHAR(128)          DEFAULT NULL,
  `file_url`       VARCHAR(500)          DEFAULT NULL COMMENT '协议文件',
  `start_date`     DATE                  DEFAULT NULL,
  `end_date`       DATE                  DEFAULT NULL,
  `settle_type`    VARCHAR(20)           DEFAULT NULL,
  `status`         TINYINT      NOT NULL DEFAULT 1,
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供货协议';

DROP TABLE IF EXISTS `supplier_qualification`;
CREATE TABLE `supplier_qualification` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `supplier_id` BIGINT       NOT NULL,
  `qual_type`   VARCHAR(20)  NOT NULL COMMENT 'QUARANTINE检疫合格证/SC食品生产许可/BUSINESS营业执照/INSPECTION检测报告',
  `qual_no`     VARCHAR(128)          DEFAULT NULL,
  `file_url`    VARCHAR(500)          DEFAULT NULL,
  `issue_date`  DATE                  DEFAULT NULL,
  `expire_date` DATE                  DEFAULT NULL,
  `audit_status` VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/REJECTED',
  `audit_remark` VARCHAR(255)         DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商资质/检疫证明(审核)';

DROP TABLE IF EXISTS `purchase_plan`;
CREATE TABLE `purchase_plan` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `plan_no`       VARCHAR(64)  NOT NULL,
  `store_id`      BIGINT       NOT NULL,
  `plan_date`     DATE         NOT NULL,
  `status`        VARCHAR(20)  NOT NULL DEFAULT 'DRAFT' COMMENT 'DRAFT草稿/SUBMITTED已提交/DONE已采购',
  `total_amount`  DECIMAL(12,2) DEFAULT 0.00,
  `remark`        VARCHAR(255)          DEFAULT NULL,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plan_no` (`plan_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购计划';

DROP TABLE IF EXISTS `purchase_order`;
CREATE TABLE `purchase_order` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `purchase_no`   VARCHAR(64)  NOT NULL COMMENT '供货单号',
  `supplier_id`   BIGINT       NOT NULL,
  `store_id`      BIGINT       NOT NULL,
  `total_amount`  DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `settle_amount` DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '已结算金额',
  `status`        VARCHAR(20)  NOT NULL DEFAULT 'CREATED' COMMENT 'CREATED待发货/DELIVERING配送中/RECEIVED已入库/CHECKING对账中/SETTLED已结算',
  `expect_date`   DATE                  DEFAULT NULL COMMENT '期望到货',
  `receive_time`  DATETIME              DEFAULT NULL,
  `inventory_id`  BIGINT                DEFAULT NULL COMMENT '入库单',
  `remark`        VARCHAR(255)          DEFAULT NULL,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_purchase_no` (`purchase_no`),
  KEY `idx_supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供货单/采购单';

DROP TABLE IF EXISTS `purchase_item`;
CREATE TABLE `purchase_item` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `purchase_id`   BIGINT       NOT NULL,
  `product_id`    BIGINT                DEFAULT NULL,
  `product_name`  VARCHAR(128) NOT NULL,
  `spec`          VARCHAR(128)          DEFAULT NULL,
  `price`         DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '供货单价',
  `quantity`      DECIMAL(12,3) NOT NULL DEFAULT 0.000,
  `unit`          VARCHAR(16)           DEFAULT 'kg',
  `amount`        DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_purchase` (`purchase_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供货单明细';

DROP TABLE IF EXISTS `supplier_delivery`;
CREATE TABLE `supplier_delivery` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `delivery_no`   VARCHAR(64)  NOT NULL,
  `purchase_id`   BIGINT       NOT NULL,
  `supplier_id`   BIGINT       NOT NULL,
  `delivery_time` DATETIME              DEFAULT NULL,
  `driver`        VARCHAR(64)           DEFAULT NULL,
  `driver_phone`  VARCHAR(20)           DEFAULT NULL,
  `cold_chain_temp` DECIMAL(5,2)        DEFAULT NULL COMMENT '冷链温度(℃)',
  `status`        VARCHAR(20)  NOT NULL DEFAULT 'DELIVERING' COMMENT 'DELIVERING/RECEIVED',
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_delivery_no` (`delivery_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='送货单';

DROP TABLE IF EXISTS `inventory_record`;
CREATE TABLE `inventory_record` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT,
  `store_id`     BIGINT       NOT NULL,
  `product_id`   BIGINT       NOT NULL,
  `record_type`  VARCHAR(20)  NOT NULL COMMENT 'IN入库/OUT出库/LOSS损耗/CHECK盘点',
  `quantity`     DECIMAL(12,3) NOT NULL DEFAULT 0.000,
  `before_stock` DECIMAL(12,3)         DEFAULT 0.000,
  `after_stock`  DECIMAL(12,3)         DEFAULT 0.000,
  `biz_no`       VARCHAR(64)           DEFAULT NULL COMMENT '关联单号',
  `remark`       VARCHAR(255)          DEFAULT NULL,
  `create_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`      TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_store_product` (`store_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='出入库/损耗记录';

DROP TABLE IF EXISTS `supplier_settlement`;
CREATE TABLE `supplier_settlement` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `settle_no`      VARCHAR(64)  NOT NULL,
  `supplier_id`    BIGINT       NOT NULL,
  `period_start`   DATE                  DEFAULT NULL,
  `period_end`     DATE                  DEFAULT NULL,
  `amount`         DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '应付金额',
  `paid_amount`    DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '已付金额',
  `status`         VARCHAR(20)  NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING待对账/CONFIRMED已对账/PAID已付款',
  `remark`         VARCHAR(255)          DEFAULT NULL,
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_settle_no` (`settle_no`),
  KEY `idx_supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商对账单/结算';

DROP TABLE IF EXISTS `inventory_warning`;
CREATE TABLE `inventory_warning` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `store_id`    BIGINT       NOT NULL,
  `product_id`  BIGINT       NOT NULL,
  `sku_id`      BIGINT                DEFAULT NULL,
  `current_stock` DECIMAL(12,3)       DEFAULT 0.000,
  `warn_stock`  DECIMAL(12,3)         DEFAULT 0.000,
  `status`      VARCHAR(20)  NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING待处理/HANDLED已处理',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_store` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存预警';

-- =============================================================
-- 八、渠道商：档案 / 佣金规则 / 报单 / 结算 / 专属价
-- =============================================================

DROP TABLE IF EXISTS `channel`;
CREATE TABLE `channel` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `code`           VARCHAR(64)  NOT NULL,
  `name`           VARCHAR(128) NOT NULL COMMENT '渠道商名称',
  `user_id`        BIGINT                DEFAULT NULL,
  `parent_id`      BIGINT       NOT NULL DEFAULT 0 COMMENT '上级渠道商',
  `level`          INT          NOT NULL DEFAULT 1 COMMENT '层级',
  `channel_type`   VARCHAR(20)  NOT NULL DEFAULT 'DISTRIBUTOR' COMMENT 'GROUP团购/DISTRIBUTOR分销/FRANCHISE加盟',
  `contact`        VARCHAR(64)           DEFAULT NULL,
  `phone`          VARCHAR(20)           DEFAULT NULL,
  `commission_rate` DECIMAL(6,2)         DEFAULT 0.00 COMMENT '默认佣金比例(%)',
  `credit_limit`   DECIMAL(12,2)         DEFAULT 0.00 COMMENT '额度',
  `used_credit`    DECIMAL(12,2)         DEFAULT 0.00 COMMENT '已用额度',
  `store_ids`      VARCHAR(255)          DEFAULT NULL COMMENT '可销售门店',
  `status`         TINYINT      NOT NULL DEFAULT 1 COMMENT '1合作 0停用',
  `remark`         VARCHAR(255)          DEFAULT NULL,
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_code` (`code`),
  KEY `idx_parent` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='渠道商档案(团购/分销/加盟)';

DROP TABLE IF EXISTS `channel_commission_rule`;
CREATE TABLE `channel_commission_rule` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `name`          VARCHAR(128) NOT NULL,
  `channel_id`    BIGINT                DEFAULT NULL COMMENT '为空=全局规则',
  `biz_type`      VARCHAR(20)           DEFAULT NULL COMMENT '适用品类,空=全部',
  `product_id`    BIGINT                DEFAULT NULL COMMENT '指定商品',
  `level`         INT          NOT NULL DEFAULT 1 COMMENT '层级 1一级 2二级',
  `rule_type`     VARCHAR(20)  NOT NULL DEFAULT 'RATE' COMMENT 'RATE按比例/FIXED固定金额',
  `rate`          DECIMAL(6,2)          DEFAULT 0.00 COMMENT '佣金比例(%)',
  `fixed_amount`  DECIMAL(10,2)         DEFAULT 0.00 COMMENT '固定佣金',
  `status`        TINYINT      NOT NULL DEFAULT 1,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_channel` (`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='佣金规则(后台可配)';

DROP TABLE IF EXISTS `channel_order`;
CREATE TABLE `channel_order` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `report_no`     VARCHAR(64)  NOT NULL COMMENT '报单号',
  `channel_id`    BIGINT       NOT NULL,
  `order_id`      BIGINT                DEFAULT NULL COMMENT '关联订单',
  `order_no`      VARCHAR(64)           DEFAULT NULL,
  `store_id`      BIGINT                DEFAULT NULL,
  `amount`        DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `commission`    DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '佣金',
  `commission_rule_id` BIGINT           DEFAULT NULL,
  `status`        VARCHAR(20)  NOT NULL DEFAULT 'SUBMITTED' COMMENT 'SUBMITTED待审核/APPROVED已通过/REJECTED已驳回/SETTLED已结算',
  `audit_remark`  VARCHAR(255)          DEFAULT NULL,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_report_no` (`report_no`),
  KEY `idx_channel` (`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='渠道报单';

DROP TABLE IF EXISTS `channel_settlement`;
CREATE TABLE `channel_settlement` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT,
  `settle_no`    VARCHAR(64)  NOT NULL,
  `channel_id`   BIGINT       NOT NULL,
  `period_start` DATE                  DEFAULT NULL,
  `period_end`   DATE                  DEFAULT NULL,
  `amount`       DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT '应结佣金',
  `paid_amount`  DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `status`       VARCHAR(20)  NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING待结算/CONFIRMED已确认/PAID已打款',
  `remark`       VARCHAR(255)          DEFAULT NULL,
  `create_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`      TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_settle_no` (`settle_no`),
  KEY `idx_channel` (`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='渠道商结算';

DROP TABLE IF EXISTS `channel_price`;
CREATE TABLE `channel_price` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `channel_id`  BIGINT       NOT NULL,
  `product_id`  BIGINT       NOT NULL,
  `sku_id`      BIGINT                DEFAULT NULL,
  `price`       DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '渠道专属价',
  `start_time`  DATETIME              DEFAULT NULL,
  `end_time`    DATETIME              DEFAULT NULL,
  `status`      TINYINT      NOT NULL DEFAULT 1,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_channel_product` (`channel_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='渠道专属价';

-- =============================================================
-- 九、店员 / 分割师傅端
-- =============================================================

DROP TABLE IF EXISTS `staff`;
CREATE TABLE `staff` (
  `id`              BIGINT       NOT NULL AUTO_INCREMENT,
  `user_id`         BIGINT       NOT NULL COMMENT '关联 sys_user',
  `store_id`        BIGINT       NOT NULL,
  `name`            VARCHAR(64)  NOT NULL,
  `phone`           VARCHAR(20)           DEFAULT NULL,
  `staff_type`      VARCHAR(20)  NOT NULL DEFAULT 'CLERK' COMMENT 'CLERK店员/CUTTER分割师傅',
  `commission_rate` DECIMAL(6,2)          DEFAULT 2.00 COMMENT '提成比例(%)',
  `status`          TINYINT      NOT NULL DEFAULT 1,
  `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`         TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_store` (`store_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='店员/分割师傅';

DROP TABLE IF EXISTS `staff_task`;
CREATE TABLE `staff_task` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `store_id`      BIGINT       NOT NULL,
  `staff_id`      BIGINT                DEFAULT NULL,
  `order_id`      BIGINT                DEFAULT NULL,
  `order_no`      VARCHAR(64)           DEFAULT NULL,
  `task_type`     VARCHAR(20)  NOT NULL DEFAULT 'PREPARE' COMMENT 'PREPARE备货/SPLIT分割/PICK配货/DELIVER配送',
  `task_date`     DATE                  DEFAULT NULL,
  `content`       VARCHAR(500)          DEFAULT NULL,
  `status`        VARCHAR(20)  NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING待办/DOING进行中/DONE已完成',
  `finish_time`   DATETIME              DEFAULT NULL,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_store_date` (`store_id`,`task_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='店员备货/配货待办';

DROP TABLE IF EXISTS `staff_split_record`;
CREATE TABLE `staff_split_record` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `store_id`      BIGINT       NOT NULL,
  `staff_id`      BIGINT       NOT NULL,
  `order_id`      BIGINT                DEFAULT NULL,
  `order_no`      VARCHAR(64)           DEFAULT NULL,
  `order_item_id` BIGINT                DEFAULT NULL,
  `product_name`  VARCHAR(128)          DEFAULT NULL,
  `split_type`    VARCHAR(20)  NOT NULL COMMENT 'CUBE切块/MINCED绞肉/SLICED切片',
  `weight`        DECIMAL(10,3)         DEFAULT 0.000 COMMENT '加工重量(kg)',
  `loss_weight`   DECIMAL(10,3)         DEFAULT 0.000 COMMENT '损耗重量(kg)',
  `split_fee`     DECIMAL(10,2)         DEFAULT 0.00 COMMENT '加工费',
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_staff` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分割加工登记';

DROP TABLE IF EXISTS `staff_order`;
CREATE TABLE `staff_order` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `order_no`      VARCHAR(64)  NOT NULL COMMENT '称重开单号',
  `store_id`      BIGINT       NOT NULL,
  `staff_id`      BIGINT       NOT NULL,
  `member_id`     BIGINT                DEFAULT NULL,
  `product_id`    BIGINT                DEFAULT NULL,
  `product_name`  VARCHAR(128)          DEFAULT NULL,
  `weight`        DECIMAL(10,3)         DEFAULT 0.000 COMMENT '实称重量(kg)',
  `price`         DECIMAL(10,2)         DEFAULT 0.00,
  `amount`        DECIMAL(12,2)         DEFAULT 0.00,
  `pay_type`      VARCHAR(20)           DEFAULT 'CASH' COMMENT 'CASH/WECHAT/BALANCE',
  `commission`    DECIMAL(10,2)         DEFAULT 0.00 COMMENT '提成',
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_staff_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='称重开单';

DROP TABLE IF EXISTS `staff_performance`;
CREATE TABLE `staff_performance` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `staff_id`       BIGINT       NOT NULL,
  `store_id`       BIGINT       NOT NULL,
  `stat_date`      DATE         NOT NULL,
  `order_count`    INT          NOT NULL DEFAULT 0,
  `sales_amount`   DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `split_count`    INT          NOT NULL DEFAULT 0,
  `split_weight`   DECIMAL(12,3) NOT NULL DEFAULT 0.000,
  `commission`     DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_staff_date` (`staff_id`,`stat_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='店员业绩/提成';

-- =============================================================
-- 十、支付
-- =============================================================

DROP TABLE IF EXISTS `pay_record`;
CREATE TABLE `pay_record` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `pay_no`         VARCHAR(64)  NOT NULL,
  `order_id`       BIGINT                DEFAULT NULL,
  `order_no`       VARCHAR(64)           DEFAULT NULL,
  `member_id`      BIGINT                DEFAULT NULL,
  `pay_type`       VARCHAR(20)  NOT NULL DEFAULT 'WECHAT' COMMENT 'WECHAT/BALANCE/CASH',
  `amount`         DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `out_trade_no`   VARCHAR(64)           DEFAULT NULL COMMENT '微信商户单号',
  `transaction_id` VARCHAR(64)           DEFAULT NULL COMMENT '微信支付单号',
  `status`         VARCHAR(20)  NOT NULL DEFAULT 'UNPAID' COMMENT 'UNPAID/PAID/FAILED',
  `pay_time`       DATETIME              DEFAULT NULL,
  `raw_data`       TEXT                  DEFAULT NULL COMMENT '回调原始数据',
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pay_no` (`pay_no`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付记录';

DROP TABLE IF EXISTS `refund_record`;
CREATE TABLE `refund_record` (
  `id`             BIGINT       NOT NULL AUTO_INCREMENT,
  `refund_no`      VARCHAR(64)  NOT NULL,
  `order_id`       BIGINT                DEFAULT NULL,
  `order_no`       VARCHAR(64)           DEFAULT NULL,
  `aftersale_id`   BIGINT                DEFAULT NULL,
  `amount`         DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  `refund_type`    VARCHAR(20)  NOT NULL DEFAULT 'WECHAT' COMMENT 'WECHAT/BALANCE',
  `status`         VARCHAR(20)  NOT NULL DEFAULT 'APPLYING' COMMENT 'APPLYING/SUCCESS/FAILED',
  `refund_time`    DATETIME              DEFAULT NULL,
  `remark`         VARCHAR(255)          DEFAULT NULL,
  `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`        TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_refund_no` (`refund_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='退款记录';

-- =============================================================
-- 十一、对象存储
-- =============================================================

DROP TABLE IF EXISTS `oss_config`;
CREATE TABLE `oss_config` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `driver`      VARCHAR(20)  NOT NULL COMMENT 'LOCAL/S3/OSS/COS/MINIO',
  `config_json` TEXT                  DEFAULT NULL COMMENT '驱动参数(敏感字段加密)',
  `is_default`  TINYINT      NOT NULL DEFAULT 0,
  `status`      TINYINT      NOT NULL DEFAULT 1,
  `test_result` VARCHAR(255)          DEFAULT NULL COMMENT '最近连接测试结果',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='对象存储配置(5驱动可切)';

DROP TABLE IF EXISTS `oss_file`;
CREATE TABLE `oss_file` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `file_name`   VARCHAR(255)          DEFAULT NULL,
  `file_path`   VARCHAR(500)          DEFAULT NULL COMMENT '存储路径/key',
  `url`         VARCHAR(1000)         DEFAULT NULL,
  `file_size`   BIGINT                DEFAULT 0,
  `content_type` VARCHAR(64)          DEFAULT NULL,
  `driver`      VARCHAR(20)           DEFAULT NULL,
  `biz_type`    VARCHAR(32)           DEFAULT NULL COMMENT '业务类型',
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='上传文件';

-- =============================================================
-- 十二、官网 CMS
-- =============================================================

DROP TABLE IF EXISTS `cms_category`;
CREATE TABLE `cms_category` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(64)  NOT NULL,
  `name_en`     VARCHAR(64)           DEFAULT NULL,
  `code`        VARCHAR(64)           DEFAULT NULL,
  `sort`        INT          NOT NULL DEFAULT 0,
  `status`      TINYINT      NOT NULL DEFAULT 1,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CMS 栏目';

DROP TABLE IF EXISTS `cms_article`;
CREATE TABLE `cms_article` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `category_id`   BIGINT                DEFAULT NULL,
  `title`         VARCHAR(200) NOT NULL,
  `title_en`      VARCHAR(200)          DEFAULT NULL,
  `summary`       VARCHAR(500)          DEFAULT NULL,
  `summary_en`    VARCHAR(500)          DEFAULT NULL,
  `content`       LONGTEXT              DEFAULT NULL COMMENT '富文本(WangEditor)',
  `content_en`    LONGTEXT              DEFAULT NULL COMMENT '英文富文本',
  `cover`         VARCHAR(500)          DEFAULT NULL,
  `author`        VARCHAR(64)           DEFAULT NULL,
  `source`        VARCHAR(64)           DEFAULT NULL,
  `seo_keywords`  VARCHAR(255)          DEFAULT NULL,
  `seo_desc`      VARCHAR(500)          DEFAULT NULL,
  `article_type`  VARCHAR(20)  NOT NULL DEFAULT 'NEWS' COMMENT 'NEWS资讯/BRAND品牌故事/CASE案例/PAGE单页',
  `views`         INT          NOT NULL DEFAULT 0,
  `is_top`        TINYINT      NOT NULL DEFAULT 0,
  `status`        TINYINT      NOT NULL DEFAULT 1 COMMENT '1发布 0草稿',
  `publish_time`  DATETIME              DEFAULT NULL,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_type` (`article_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CMS 文章/资讯/品牌故事/案例';

DROP TABLE IF EXISTS `cms_banner`;
CREATE TABLE `cms_banner` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `title`       VARCHAR(128)          DEFAULT NULL,
  `title_en`    VARCHAR(128)          DEFAULT NULL,
  `image`       VARCHAR(500) NOT NULL,
  `link_url`    VARCHAR(500)          DEFAULT NULL,
  `position`    VARCHAR(20)  NOT NULL DEFAULT 'PC_HOME' COMMENT 'PC_HOME/MINIAPP_HOME/H5/SET_BANNER',
  `sort`        INT          NOT NULL DEFAULT 0,
  `start_time`  DATETIME              DEFAULT NULL,
  `end_time`    DATETIME              DEFAULT NULL,
  `status`      TINYINT      NOT NULL DEFAULT 1,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Banner';

DROP TABLE IF EXISTS `cms_message`;
CREATE TABLE `cms_message` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT,
  `msg_type`    VARCHAR(20)  NOT NULL DEFAULT 'CONTACT' COMMENT 'CONTACT联系我们/GROUP团购企业团单',
  `name`        VARCHAR(64)           DEFAULT NULL,
  `phone`       VARCHAR(20)           DEFAULT NULL,
  `company`     VARCHAR(128)          DEFAULT NULL,
  `email`       VARCHAR(100)          DEFAULT NULL,
  `content`     VARCHAR(1000)         DEFAULT NULL,
  `city`        VARCHAR(64)           DEFAULT NULL,
  `status`      VARCHAR(20)  NOT NULL DEFAULT 'UNREAD' COMMENT 'UNREAD未读/READ已读/DONE已处理',
  `remark`      VARCHAR(255)          DEFAULT NULL,
  `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`     TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='留言/团购咨询';

-- =============================================================
-- 十三、微信公众号
-- =============================================================

DROP TABLE IF EXISTS `wechat_menu_publish`;
CREATE TABLE `wechat_menu_publish` (
  `id`           BIGINT       NOT NULL AUTO_INCREMENT,
  `menu_json`    LONGTEXT              DEFAULT NULL COMMENT '发布快照(公众号菜单 JSON)',
  `publish_user` VARCHAR(64)           DEFAULT NULL,
  `status`       VARCHAR(20)  NOT NULL DEFAULT 'SUCCESS' COMMENT 'SUCCESS/FAILED',
  `message`      VARCHAR(500)          DEFAULT NULL,
  `create_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`      TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公众号菜单发布记录';

DROP TABLE IF EXISTS `wechat_template`;
CREATE TABLE `wechat_template` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `biz_type`      VARCHAR(32)  NOT NULL COMMENT 'ORDER_PAID/ORDER_PREPARING/ORDER_READY/ORDER_DELIVERING/ACTIVITY',
  `template_id`   VARCHAR(128)          DEFAULT NULL COMMENT '微信模板ID',
  `title`         VARCHAR(128)          DEFAULT NULL,
  `content_json`  TEXT                  DEFAULT NULL COMMENT '模板字段映射',
  `status`        TINYINT      NOT NULL DEFAULT 1,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_biz_type` (`biz_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公众号模板消息配置';

DROP TABLE IF EXISTS `wechat_msg_log`;
CREATE TABLE `wechat_msg_log` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT,
  `openid`        VARCHAR(64)           DEFAULT NULL,
  `unionid`       VARCHAR(64)           DEFAULT NULL,
  `biz_type`      VARCHAR(32)           DEFAULT NULL,
  `template_id`   VARCHAR(128)          DEFAULT NULL,
  `content`       TEXT                  DEFAULT NULL,
  `status`        TINYINT      NOT NULL DEFAULT 1,
  `error_msg`     VARCHAR(500)          DEFAULT NULL,
  `create_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time`   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted`       TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模板消息发送日志';

SET FOREIGN_KEY_CHECKS = 1;
