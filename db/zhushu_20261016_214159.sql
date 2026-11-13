-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: zhushu
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '9e760694-c913-11f1-aa5b-00059a3c7a00:1-692';

--
-- Table structure for table `channel`
--

DROP TABLE IF EXISTS `channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `channel` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL,
  `name` varchar(128) NOT NULL COMMENT '渠道商名称',
  `user_id` bigint DEFAULT NULL,
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '上级渠道商',
  `level` int NOT NULL DEFAULT '1' COMMENT '层级',
  `channel_type` varchar(20) NOT NULL DEFAULT 'DISTRIBUTOR' COMMENT 'GROUP团购/DISTRIBUTOR分销/FRANCHISE加盟',
  `contact` varchar(64) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `commission_rate` decimal(6,2) DEFAULT '0.00' COMMENT '默认佣金比例(%)',
  `credit_limit` decimal(12,2) DEFAULT '0.00' COMMENT '额度',
  `used_credit` decimal(12,2) DEFAULT '0.00' COMMENT '已用额度',
  `store_ids` varchar(255) DEFAULT NULL COMMENT '可销售门店',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1合作 0停用',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_code` (`code`),
  KEY `idx_parent` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='渠道商档案(团购/分销/加盟)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel`
--

LOCK TABLES `channel` WRITE;
/*!40000 ALTER TABLE `channel` DISABLE KEYS */;
INSERT INTO `channel` VALUES (1,'QD001','某某社区团购团',8,0,1,'GROUP','陈团长','13600000001',8.00,50000.00,12000.00,NULL,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'QD002','某某分销商',NULL,0,1,'DISTRIBUTOR','周经理','13600000002',10.00,30000.00,5000.00,NULL,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'QD003','某某加盟店',NULL,0,1,'FRANCHISE','吴老板','13600000003',12.00,100000.00,30000.00,NULL,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `channel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_commission_rule`
--

DROP TABLE IF EXISTS `channel_commission_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `channel_commission_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `channel_id` bigint DEFAULT NULL COMMENT '为空=全局规则',
  `biz_type` varchar(20) DEFAULT NULL COMMENT '适用品类,空=全部',
  `product_id` bigint DEFAULT NULL COMMENT '指定商品',
  `level` int NOT NULL DEFAULT '1' COMMENT '层级 1一级 2二级',
  `rule_type` varchar(20) NOT NULL DEFAULT 'RATE' COMMENT 'RATE按比例/FIXED固定金额',
  `rate` decimal(6,2) DEFAULT '0.00' COMMENT '佣金比例(%)',
  `fixed_amount` decimal(10,2) DEFAULT '0.00' COMMENT '固定佣金',
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_channel` (`channel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='佣金规则(后台可配)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_commission_rule`
--

LOCK TABLES `channel_commission_rule` WRITE;
/*!40000 ALTER TABLE `channel_commission_rule` DISABLE KEYS */;
INSERT INTO `channel_commission_rule` VALUES (1,'全局默认佣金',NULL,NULL,NULL,1,'RATE',8.00,0.00,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'二级分销佣金',NULL,NULL,NULL,2,'RATE',3.00,0.00,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'鲜肉专项佣金',NULL,'PORK',NULL,1,'RATE',5.00,0.00,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,'火锅食材佣金',NULL,'HOTPOT',NULL,1,'RATE',10.00,0.00,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `channel_commission_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_order`
--

DROP TABLE IF EXISTS `channel_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `channel_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `report_no` varchar(64) NOT NULL COMMENT '报单号',
  `channel_id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL COMMENT '关联订单',
  `order_no` varchar(64) DEFAULT NULL,
  `store_id` bigint DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `commission` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '佣金',
  `commission_rule_id` bigint DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'SUBMITTED' COMMENT 'SUBMITTED待审核/APPROVED已通过/REJECTED已驳回/SETTLED已结算',
  `audit_remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_report_no` (`report_no`),
  KEY `idx_channel` (`channel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='渠道报单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_order`
--

LOCK TABLES `channel_order` WRITE;
/*!40000 ALTER TABLE `channel_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `channel_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_price`
--

DROP TABLE IF EXISTS `channel_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `channel_price` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `channel_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `sku_id` bigint DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '渠道专属价',
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_channel_product` (`channel_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='渠道专属价';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_price`
--

LOCK TABLES `channel_price` WRITE;
/*!40000 ALTER TABLE `channel_price` DISABLE KEYS */;
/*!40000 ALTER TABLE `channel_price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `channel_settlement`
--

DROP TABLE IF EXISTS `channel_settlement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `channel_settlement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `settle_no` varchar(64) NOT NULL,
  `channel_id` bigint NOT NULL,
  `period_start` date DEFAULT NULL,
  `period_end` date DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '应结佣金',
  `paid_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING待结算/CONFIRMED已确认/PAID已打款',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_channel_settle_no` (`settle_no`),
  KEY `idx_channel` (`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='渠道商结算';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `channel_settlement`
--

LOCK TABLES `channel_settlement` WRITE;
/*!40000 ALTER TABLE `channel_settlement` DISABLE KEYS */;
/*!40000 ALTER TABLE `channel_settlement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_article`
--

DROP TABLE IF EXISTS `cms_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cms_article` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_id` bigint DEFAULT NULL,
  `title` varchar(200) NOT NULL,
  `title_en` varchar(200) DEFAULT NULL,
  `summary` varchar(500) DEFAULT NULL,
  `summary_en` varchar(500) DEFAULT NULL,
  `content` longtext COMMENT '富文本(WangEditor)',
  `content_en` longtext COMMENT '英文富文本',
  `cover` varchar(500) DEFAULT NULL,
  `author` varchar(64) DEFAULT NULL,
  `source` varchar(64) DEFAULT NULL,
  `seo_keywords` varchar(255) DEFAULT NULL,
  `seo_desc` varchar(500) DEFAULT NULL,
  `article_type` varchar(20) NOT NULL DEFAULT 'NEWS' COMMENT 'NEWS资讯/BRAND品牌故事/CASE案例/PAGE单页',
  `views` int NOT NULL DEFAULT '0',
  `is_top` tinyint NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1发布 0草稿',
  `publish_time` datetime DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_type` (`article_type`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='CMS 文章/资讯/品牌故事/案例';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_article`
--

LOCK TABLES `cms_article` WRITE;
/*!40000 ALTER TABLE `cms_article` DISABLE KEYS */;
INSERT INTO `cms_article` VALUES (1,1,'猪事大吉：把鲜肉铺搬进社区','ZhuShi DaJi: Fresh Meat in Community','诸事大吉的谐音，做社区一站式鲜肉与火锅食材超市',NULL,'<p>猪事大吉，取“诸事大吉”谐音，专注社区鲜肉、火锅食材与肉制品。</p>',NULL,NULL,NULL,NULL,NULL,NULL,'BRAND',0,1,1,'2026-10-16 18:59:58','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,1,'为什么选择当日冷鲜猪肉','Why Daily Chilled Pork','两证两章，全程冷链',NULL,'<p>每一批猪肉均附动物产品检疫合格证明与肉品品质检验合格证。</p>',NULL,NULL,NULL,NULL,NULL,NULL,'NEWS',0,0,1,'2026-10-16 18:59:58','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,3,'某社区团购合作案例','Community Group Buy Case','月均团购 3 万单',NULL,'<p>通过渠道商报单与结算闭环，实现高效分销。</p>',NULL,NULL,NULL,NULL,NULL,NULL,'CASE',0,0,1,'2026-10-16 18:59:58','2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `cms_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_banner`
--

DROP TABLE IF EXISTS `cms_banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cms_banner` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(128) DEFAULT NULL,
  `title_en` varchar(128) DEFAULT NULL,
  `image` varchar(500) NOT NULL,
  `link_url` varchar(500) DEFAULT NULL,
  `position` varchar(20) NOT NULL DEFAULT 'PC_HOME' COMMENT 'PC_HOME/MINIAPP_HOME/H5/SET_BANNER',
  `sort` int NOT NULL DEFAULT '0',
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Banner';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_banner`
--

LOCK TABLES `cms_banner` WRITE;
/*!40000 ALTER TABLE `cms_banner` DISABLE KEYS */;
INSERT INTO `cms_banner` VALUES (1,'猪事大吉 · 社区鲜肉','ZhuShi DaJi Fresh Meat','/static/banner1.jpg','/products','PC_HOME',1,NULL,NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'火锅到家 · 一站备齐','Hotpot to Home','/static/banner2.jpg','/products','PC_HOME',2,NULL,NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'猪事大吉','ZhuShi DaJi','/static/mini-banner1.jpg','/pages/reserve/index','MINIAPP_HOME',1,NULL,NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `cms_banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_category`
--

DROP TABLE IF EXISTS `cms_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cms_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `name_en` varchar(64) DEFAULT NULL,
  `code` varchar(64) DEFAULT NULL,
  `sort` int NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='CMS 栏目';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_category`
--

LOCK TABLES `cms_category` WRITE;
/*!40000 ALTER TABLE `cms_category` DISABLE KEYS */;
INSERT INTO `cms_category` VALUES (1,'品牌动态','Brand News','news',1,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'行业资讯','Industry','industry',2,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'客户案例','Cases','case',3,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `cms_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_message`
--

DROP TABLE IF EXISTS `cms_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cms_message` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `msg_type` varchar(20) NOT NULL DEFAULT 'CONTACT' COMMENT 'CONTACT联系我们/GROUP团购企业团单',
  `name` varchar(64) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `company` varchar(128) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `content` varchar(1000) DEFAULT NULL,
  `city` varchar(64) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'UNREAD' COMMENT 'UNREAD未读/READ已读/DONE已处理',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='留言/团购咨询';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_message`
--

LOCK TABLES `cms_message` WRITE;
/*!40000 ALTER TABLE `cms_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon`
--

DROP TABLE IF EXISTS `coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `coupon_type` varchar(20) NOT NULL DEFAULT 'CASH' COMMENT 'CASH满减/DISCOUNT折扣/FREE_DELIVERY免配送费',
  `amount` decimal(10,2) DEFAULT '0.00' COMMENT '面额',
  `discount` decimal(5,2) DEFAULT '100.00' COMMENT '折扣',
  `min_amount` decimal(10,2) DEFAULT '0.00' COMMENT '使用门槛',
  `total_count` int NOT NULL DEFAULT '0' COMMENT '发放总量',
  `received_count` int NOT NULL DEFAULT '0' COMMENT '已领取',
  `per_limit` int NOT NULL DEFAULT '1' COMMENT '每人限领',
  `scope_store` varchar(255) DEFAULT NULL COMMENT '适用门店(逗号),空=全部',
  `scope_biz_type` varchar(128) DEFAULT NULL COMMENT '适用品类',
  `valid_type` varchar(20) NOT NULL DEFAULT 'FIXED' COMMENT 'FIXED固定日期/DAYS领取后N天',
  `valid_days` int DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1上架 0下架',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='优惠券';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
INSERT INTO `coupon` VALUES (1,'满 99 减 10','CASH',10.00,100.00,99.00,1000,12,1,NULL,NULL,'DAYS',30,NULL,NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'满 199 减 30','CASH',30.00,100.00,199.00,500,5,1,NULL,NULL,'DAYS',30,NULL,NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'鲜肉 95 折券','DISCOUNT',0.00,95.00,50.00,300,3,1,NULL,NULL,'DAYS',15,NULL,NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,'火锅套餐免配送费','FREE_DELIVERY',0.00,100.00,0.00,200,1,1,NULL,NULL,'DAYS',7,NULL,NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_record`
--

DROP TABLE IF EXISTS `inventory_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `store_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `record_type` varchar(20) NOT NULL COMMENT 'IN入库/OUT出库/LOSS损耗/CHECK盘点',
  `quantity` decimal(12,3) NOT NULL DEFAULT '0.000',
  `before_stock` decimal(12,3) DEFAULT '0.000',
  `after_stock` decimal(12,3) DEFAULT '0.000',
  `biz_no` varchar(64) DEFAULT NULL COMMENT '关联单号',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_store_product` (`store_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='出入库/损耗记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_record`
--

LOCK TABLES `inventory_record` WRITE;
/*!40000 ALTER TABLE `inventory_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_warning`
--

DROP TABLE IF EXISTS `inventory_warning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_warning` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `store_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `sku_id` bigint DEFAULT NULL,
  `current_stock` decimal(12,3) DEFAULT '0.000',
  `warn_stock` decimal(12,3) DEFAULT '0.000',
  `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING待处理/HANDLED已处理',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_store` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='库存预警';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_warning`
--

LOCK TABLES `inventory_warning` WRITE;
/*!40000 ALTER TABLE `inventory_warning` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_warning` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `unionid` varchar(64) DEFAULT NULL COMMENT '微信 UnionID',
  `openid` varchar(64) DEFAULT NULL COMMENT '小程序 openid',
  `mp_openid` varchar(64) DEFAULT NULL COMMENT '公众号 openid',
  `nickname` varchar(64) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `gender` tinyint DEFAULT '0',
  `level_id` bigint DEFAULT NULL COMMENT '会员等级',
  `balance` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '储值余额',
  `points` int NOT NULL DEFAULT '0' COMMENT '积分',
  `total_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '累计消费',
  `default_store_id` bigint DEFAULT NULL COMMENT '常用门店',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1正常 0禁用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_unionid` (`unionid`),
  KEY `idx_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,'oU_union_001','oM_open_001',NULL,'张伟',NULL,'13900000001',0,2,200.00,320,680.00,1,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'oU_union_002','oM_open_002',NULL,'李娜',NULL,'13900000002',0,1,0.00,45,120.00,1,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'oU_union_003','oM_open_003',NULL,'王强',NULL,'13900000003',0,3,500.00,1580,3200.00,2,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_balance_log`
--

DROP TABLE IF EXISTS `member_balance_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_balance_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `member_id` bigint NOT NULL,
  `change_type` varchar(20) NOT NULL COMMENT 'RECHARGE充值/CONSUME消费/REFUND退款/ADJUST调整',
  `amount` decimal(12,2) NOT NULL COMMENT '变动金额(正增负减)',
  `balance` decimal(12,2) NOT NULL COMMENT '变动后余额',
  `biz_no` varchar(64) DEFAULT NULL COMMENT '关联单号',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='储值流水';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_balance_log`
--

LOCK TABLES `member_balance_log` WRITE;
/*!40000 ALTER TABLE `member_balance_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_balance_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_coupon`
--

DROP TABLE IF EXISTS `member_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `coupon_id` bigint NOT NULL,
  `member_id` bigint NOT NULL,
  `code` varchar(64) DEFAULT NULL COMMENT '券码',
  `status` varchar(20) NOT NULL DEFAULT 'UNUSED' COMMENT 'UNUSED/USED/EXPIRED',
  `order_id` bigint DEFAULT NULL COMMENT '使用订单',
  `use_time` datetime DEFAULT NULL,
  `expire_time` datetime DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员优惠券';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_coupon`
--

LOCK TABLES `member_coupon` WRITE;
/*!40000 ALTER TABLE `member_coupon` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_level`
--

DROP TABLE IF EXISTS `member_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_level` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL COMMENT '等级名称',
  `level` int NOT NULL DEFAULT '1',
  `upgrade_amount` decimal(10,2) DEFAULT '0.00' COMMENT '升级所需累计消费',
  `discount` decimal(5,2) DEFAULT '100.00' COMMENT '折扣(百分数 95=95折)',
  `points_ratio` decimal(6,2) DEFAULT '1.00' COMMENT '积分倍率',
  `icon` varchar(255) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员等级';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_level`
--

LOCK TABLES `member_level` WRITE;
/*!40000 ALTER TABLE `member_level` DISABLE KEYS */;
INSERT INTO `member_level` VALUES (1,'普通会员',1,0.00,100.00,1.00,NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'银卡会员',2,500.00,98.00,1.20,NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'金卡会员',3,2000.00,95.00,1.50,NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `member_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_points_log`
--

DROP TABLE IF EXISTS `member_points_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_points_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `member_id` bigint NOT NULL,
  `change_type` varchar(20) NOT NULL COMMENT 'EARN获得/USE使用/REFUND退回/ADJUST调整',
  `points` int NOT NULL COMMENT '变动积分',
  `balance` int NOT NULL COMMENT '变动后积分',
  `biz_no` varchar(64) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='积分流水';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_points_log`
--

LOCK TABLES `member_points_log` WRITE;
/*!40000 ALTER TABLE `member_points_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_points_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_aftersale`
--

DROP TABLE IF EXISTS `order_aftersale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_aftersale` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `aftersale_no` varchar(64) NOT NULL,
  `order_id` bigint NOT NULL,
  `order_no` varchar(64) DEFAULT NULL,
  `member_id` bigint DEFAULT NULL,
  `aftersale_type` varchar(20) NOT NULL DEFAULT 'REFUND' COMMENT 'REFUND退款/RETURN退货/EXCHANGE换货',
  `reason` varchar(255) DEFAULT NULL,
  `images` varchar(1000) DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `status` varchar(20) NOT NULL DEFAULT 'APPLYING' COMMENT 'APPLYING待审核/AGREED已同意/REJECTED已拒绝/DONE已完成',
  `audit_remark` varchar(255) DEFAULT NULL,
  `audit_time` datetime DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单售后';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_aftersale`
--

LOCK TABLES `order_aftersale` WRITE;
/*!40000 ALTER TABLE `order_aftersale` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_aftersale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_info`
--

DROP TABLE IF EXISTS `order_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_info` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(64) NOT NULL COMMENT '订单号',
  `member_id` bigint NOT NULL,
  `store_id` bigint NOT NULL,
  `order_type` varchar(20) NOT NULL DEFAULT 'NORMAL' COMMENT 'NORMAL普通/RESERVE鲜肉预订/SET火锅套餐/GIFT礼盒',
  `source` varchar(20) NOT NULL DEFAULT 'MINIAPP' COMMENT 'MINIAPP/H5/PC/STAFF/CHANNEL',
  `status` varchar(20) NOT NULL DEFAULT 'UNPAID' COMMENT 'UNPAID待支付/PREPARING待备货/READY待取货/DELIVERING配送中/COMPLETED已完成/CANCELLED已取消/AFTERSALE售后',
  `delivery_type` varchar(20) NOT NULL DEFAULT 'SELF_PICKUP' COMMENT 'SELF_PICKUP自提/DELIVERY配送',
  `appoint_date` date DEFAULT NULL COMMENT '预订/取货日期',
  `appoint_slot` varchar(32) DEFAULT NULL COMMENT '时间段',
  `receiver_name` varchar(64) DEFAULT NULL,
  `receiver_phone` varchar(20) DEFAULT NULL,
  `receiver_address` varchar(255) DEFAULT NULL,
  `total_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '商品总额',
  `split_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '分割加工费',
  `delivery_fee` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '配送费',
  `discount_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '优惠金额',
  `pay_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '实付金额',
  `cost_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '成本金额(损耗核算)',
  `pay_status` varchar(20) NOT NULL DEFAULT 'UNPAID' COMMENT 'UNPAID/PAID/REFUNDED/PART_REFUND',
  `pay_type` varchar(20) DEFAULT NULL COMMENT 'WECHAT/BALANCE/CASH',
  `pay_time` datetime DEFAULT NULL,
  `channel_id` bigint DEFAULT NULL COMMENT '渠道商ID',
  `staff_id` bigint DEFAULT NULL COMMENT '开单店员',
  `remark` varchar(500) DEFAULT NULL COMMENT '买家备注',
  `cancel_reason` varchar(255) DEFAULT NULL,
  `finish_time` datetime DEFAULT NULL,
  `expire_time` datetime DEFAULT NULL COMMENT '支付超时时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_member` (`member_id`),
  KEY `idx_store` (`store_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_info`
--

LOCK TABLES `order_info` WRITE;
/*!40000 ALTER TABLE `order_info` DISABLE KEYS */;
INSERT INTO `order_info` VALUES (1,'ZS202610160001',1,1,'RESERVE','MINIAPP','PREPARING','SELF_PICKUP','2026-10-16',NULL,'张伟','13900000001',NULL,97.60,2.00,0.00,10.00,89.60,78.00,'PAID','WECHAT','2026-10-16 18:59:58',NULL,NULL,NULL,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'ZS202610160002',2,1,'NORMAL','MINIAPP','READY','DELIVERY',NULL,NULL,'李娜','13900000002','西城区某某小区 3 号楼',48.70,0.00,5.00,0.00,53.70,35.00,'PAID','WECHAT','2026-10-16 18:59:58',NULL,NULL,NULL,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'ZS202610160003',3,2,'SET','H5','COMPLETED','SELF_PICKUP',NULL,NULL,'王强','13900000003',NULL,128.00,0.00,0.00,0.00,128.00,92.00,'PAID','WECHAT','2026-10-16 18:59:58',NULL,NULL,NULL,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,'ZS202610160004',1,1,'GIFT','MINIAPP','UNPAID','DELIVERY',NULL,NULL,'张伟','13900000001','西城区某某小区',59.00,0.00,5.00,0.00,64.00,42.00,'UNPAID',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `order_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `order_no` varchar(64) NOT NULL,
  `product_id` bigint NOT NULL,
  `sku_id` bigint DEFAULT NULL,
  `product_name` varchar(128) NOT NULL,
  `sku_name` varchar(128) DEFAULT NULL,
  `cover` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `quantity` int NOT NULL DEFAULT '1',
  `weight` decimal(10,3) DEFAULT '0.000' COMMENT '预估重量(kg)',
  `actual_weight` decimal(10,3) DEFAULT NULL COMMENT '实称重量(kg)',
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `split_type` varchar(20) DEFAULT NULL COMMENT '分割选项 CUBE切块/MINCED绞肉/SLICED切片',
  `split_fee` decimal(10,2) DEFAULT '0.00',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单明细';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,1,'ZS202610160001',1,1,'精品五花肉','五花肉 500g',NULL,32.80,2,1.000,NULL,65.60,'CUBE',2.00,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,1,'ZS202610160001',3,4,'肋排','肋排 500g',NULL,32.00,1,0.500,NULL,32.00,NULL,0.00,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,2,'ZS202610160002',5,6,'肥牛卷','肥牛卷 300g',NULL,28.80,1,0.300,NULL,28.80,NULL,0.00,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,2,'ZS202610160002',6,7,'牛肉丸','牛肉丸 250g',NULL,19.90,1,0.250,NULL,19.90,NULL,0.00,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,3,'ZS202610160003',9,10,'火锅到家套餐(3-4人)','标准套',NULL,128.00,1,2.000,NULL,128.00,NULL,0.00,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(6,4,'ZS202610160004',7,8,'火腿肠礼盒','火腿肠礼盒 8支',NULL,59.00,1,0.800,NULL,59.00,NULL,0.00,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_log`
--

DROP TABLE IF EXISTS `order_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `order_no` varchar(64) DEFAULT NULL,
  `from_status` varchar(20) DEFAULT NULL,
  `to_status` varchar(20) DEFAULT NULL,
  `operator` varchar(64) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单状态日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_log`
--

LOCK TABLES `order_log` WRITE;
/*!40000 ALTER TABLE `order_log` DISABLE KEYS */;
INSERT INTO `order_log` VALUES (1,1,'ZS202610160001','UNPAID','PREPARING','system','支付成功','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,2,'ZS202610160002','UNPAID','READY','store01','已备货待取货','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,3,'ZS202610160003','DELIVERING','COMPLETED','system','确认收货','2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `order_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oss_config`
--

DROP TABLE IF EXISTS `oss_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oss_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `driver` varchar(20) NOT NULL COMMENT 'LOCAL/S3/OSS/COS/MINIO',
  `config_json` text COMMENT '驱动参数(敏感字段加密)',
  `is_default` tinyint NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1',
  `test_result` varchar(255) DEFAULT NULL COMMENT '最近连接测试结果',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='对象存储配置(5驱动可切)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oss_config`
--

LOCK TABLES `oss_config` WRITE;
/*!40000 ALTER TABLE `oss_config` DISABLE KEYS */;
INSERT INTO `oss_config` VALUES (1,'LOCAL','{\"uploadPath\":\"./uploads\",\"urlPrefix\":\"/uploads\"}',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `oss_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oss_file`
--

DROP TABLE IF EXISTS `oss_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oss_file` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(500) DEFAULT NULL COMMENT '存储路径/key',
  `url` varchar(1000) DEFAULT NULL,
  `file_size` bigint DEFAULT '0',
  `content_type` varchar(64) DEFAULT NULL,
  `driver` varchar(20) DEFAULT NULL,
  `biz_type` varchar(32) DEFAULT NULL COMMENT '业务类型',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='上传文件';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oss_file`
--

LOCK TABLES `oss_file` WRITE;
/*!40000 ALTER TABLE `oss_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `oss_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pay_record`
--

DROP TABLE IF EXISTS `pay_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pay_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `pay_no` varchar(64) NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `order_no` varchar(64) DEFAULT NULL,
  `member_id` bigint DEFAULT NULL,
  `pay_type` varchar(20) NOT NULL DEFAULT 'WECHAT' COMMENT 'WECHAT/BALANCE/CASH',
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `out_trade_no` varchar(64) DEFAULT NULL COMMENT '微信商户单号',
  `transaction_id` varchar(64) DEFAULT NULL COMMENT '微信支付单号',
  `status` varchar(20) NOT NULL DEFAULT 'UNPAID' COMMENT 'UNPAID/PAID/FAILED',
  `pay_time` datetime DEFAULT NULL,
  `raw_data` text COMMENT '回调原始数据',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pay_no` (`pay_no`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支付记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pay_record`
--

LOCK TABLES `pay_record` WRITE;
/*!40000 ALTER TABLE `pay_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `pay_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_id` bigint NOT NULL,
  `name` varchar(128) NOT NULL,
  `sub_title` varchar(255) DEFAULT NULL COMMENT '副标题',
  `biz_type` varchar(20) NOT NULL DEFAULT 'PORK' COMMENT 'PORK/HOTPOT/PROCESSED/BASE/SET',
  `cover` varchar(255) DEFAULT NULL,
  `images` varchar(1000) DEFAULT NULL COMMENT '轮播图',
  `detail` longtext COMMENT '富文本详情(WangEditor)',
  `unit` varchar(16) DEFAULT '斤' COMMENT '单位',
  `origin` varchar(128) DEFAULT NULL COMMENT '产地',
  `shelf_life` varchar(64) DEFAULT NULL COMMENT '保质期',
  `storage_cond` varchar(128) DEFAULT NULL COMMENT '储存条件(冷链/冷藏)',
  `cook_tip` varchar(500) DEFAULT NULL COMMENT '食用/烹饪提示',
  `reservable` tinyint NOT NULL DEFAULT '0' COMMENT '是否支持鲜肉预订',
  `split_enabled` tinyint NOT NULL DEFAULT '0' COMMENT '是否支持分割选项(切块/绞肉/切片)',
  `split_fee` decimal(10,2) DEFAULT '0.00' COMMENT '分割加工费',
  `commission_rate` decimal(6,2) DEFAULT '0.00' COMMENT '分销佣金比例(%)',
  `settle_type` varchar(20) DEFAULT 'WEIGHT' COMMENT '结算方式 WEIGHT/FIXED',
  `tags` varchar(255) DEFAULT NULL COMMENT '标签(热销/新品)',
  `sales` int NOT NULL DEFAULT '0' COMMENT '销量',
  `sort` int NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0待审核 1上架 2下架',
  `audit_remark` varchar(255) DEFAULT NULL COMMENT '审核备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category_id`),
  KEY `idx_biz_type` (`biz_type`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,101,'精品五花肉','当日冷链直供 肥瘦相间','PORK',NULL,NULL,NULL,'斤','山东','冷藏 3 天','0-4℃ 冷藏','红烧/回锅/烤肉',1,1,2.00,5.00,'WEIGHT','热销',128,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,102,'鲜里脊肉','低脂高蛋白 适合儿童','PORK',NULL,NULL,NULL,'斤','山东','冷藏 3 天','0-4℃ 冷藏','炒/炸/煎',1,1,2.00,5.00,'WEIGHT','新品',86,2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,103,'肋排','炖汤首选','PORK',NULL,NULL,NULL,'斤','河北','冷藏 3 天','0-4℃ 冷藏','炖汤/糖醋',1,1,2.00,5.00,'WEIGHT',NULL,64,3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,104,'猪前腿肉(可分割)','免费分割 切块/绞肉/切片','PORK',NULL,NULL,NULL,'斤','山东','冷藏 3 天','0-4℃ 冷藏','馅料/小炒',1,1,2.00,5.00,'WEIGHT',NULL,42,4,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,201,'肥牛卷','火锅必备 雪花纹理','HOTPOT',NULL,NULL,NULL,'盒','内蒙古','冷冻 180 天','-18℃ 冷冻','涮煮 10 秒',0,0,0.00,8.00,'FIXED','热销',210,5,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(6,202,'牛肉丸','手打弹牙','HOTPOT',NULL,NULL,NULL,'袋','广东','冷冻 180 天','-18℃ 冷冻','涮煮',0,0,0.00,8.00,'FIXED',NULL,150,6,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(7,3,'火腿肠礼盒','节日送礼 8 支装','PROCESSED',NULL,NULL,NULL,'盒','河南','常温 90 天','常温阴凉','即食',0,0,0.00,10.00,'FIXED','礼盒',33,7,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(8,4,'牛油火锅底料','川味重辣','BASE',NULL,NULL,NULL,'袋','四川','常温 365 天','常温阴凉','加水煮沸',0,0,0.00,10.00,'FIXED',NULL,120,8,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(9,5,'火锅到家套餐(3-4人)','肉卷+锅底+蘸料+丸类','SET',NULL,NULL,NULL,'套','组合','冷藏 3 天','0-4℃ 冷藏','开箱即涮',0,0,0.00,6.00,'FIXED','套餐',58,9,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_category`
--

DROP TABLE IF EXISTS `product_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL,
  `name_en` varchar(64) DEFAULT NULL,
  `biz_type` varchar(20) NOT NULL DEFAULT 'PORK' COMMENT 'PORK鲜猪肉/HOTPOT火锅食材/PROCESSED肉制品/BASE火锅底料蘸料/SET套餐礼盒',
  `icon` varchar(255) DEFAULT NULL,
  `sort` int NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=205 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_category`
--

LOCK TABLES `product_category` WRITE;
/*!40000 ALTER TABLE `product_category` DISABLE KEYS */;
INSERT INTO `product_category` VALUES (1,0,'鲜猪肉','Fresh Pork','PORK',NULL,1,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,0,'火锅食材','Hotpot Ingredients','HOTPOT',NULL,2,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,0,'肉制品','Processed Meat','PROCESSED',NULL,3,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,0,'火锅底料蘸料','Base & Sauce','BASE',NULL,4,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,0,'套餐礼盒','Combo & Gift','SET',NULL,5,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(101,1,'五花肉','Pork Belly','PORK',NULL,1,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(102,1,'里脊肉','Tenderloin','PORK',NULL,2,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(103,1,'排骨','Ribs','PORK',NULL,3,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(104,1,'分割肉','Cut Pork','PORK',NULL,4,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(201,2,'牛羊肉卷','Beef & Lamb Roll','HOTPOT',NULL,1,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(202,2,'丸类','Meatballs','HOTPOT',NULL,2,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(203,2,'豆制品','Bean Products','HOTPOT',NULL,3,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(204,2,'菌菇蔬菜','Mushroom & Veg','HOTPOT',NULL,4,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `product_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_qualification`
--

DROP TABLE IF EXISTS `product_qualification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_qualification` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `qual_type` varchar(20) NOT NULL COMMENT 'QUARANTINE动物检疫合格证明/QUALITY肉品品质检验合格证/SC食品生产许可/INSPECTION检测报告',
  `qual_no` varchar(128) DEFAULT NULL COMMENT '证书编号',
  `issuer` varchar(128) DEFAULT NULL COMMENT '发证机构',
  `issue_date` date DEFAULT NULL,
  `expire_date` date DEFAULT NULL,
  `file_url` varchar(500) DEFAULT NULL COMMENT '证明文件',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1有效 0失效',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品检疫/资质证明(猪肉两证两章、SC)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_qualification`
--

LOCK TABLES `product_qualification` WRITE;
/*!40000 ALTER TABLE `product_qualification` DISABLE KEYS */;
INSERT INTO `product_qualification` VALUES (1,1,'QUARANTINE','DWS-2026-0001','北京市动物卫生监督所','2026-01-01','2026-12-31',NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,1,'QUALITY','PZ-2026-0001','北京市肉品品质检验中心','2026-01-01','2026-12-31',NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,7,'SC','SC10241010001234','河南省市场监督管理局','2025-06-01','2028-05-31',NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `product_qualification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_sku`
--

DROP TABLE IF EXISTS `product_sku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `sku_name` varchar(128) NOT NULL COMMENT '规格名 如 五花肉 500g',
  `spec` varchar(128) DEFAULT NULL COMMENT '规格描述',
  `barcode` varchar(64) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '售价',
  `market_price` decimal(10,2) DEFAULT '0.00' COMMENT '划线价',
  `cost_price` decimal(10,2) DEFAULT '0.00' COMMENT '成本价',
  `weight` decimal(10,3) DEFAULT '0.000' COMMENT '规格重量(kg)',
  `unit` varchar(16) DEFAULT '份',
  `stock` int NOT NULL DEFAULT '0' COMMENT '总库存',
  `stock_warn` int NOT NULL DEFAULT '0' COMMENT '库存预警值',
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品规格';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_sku`
--

LOCK TABLES `product_sku` WRITE;
/*!40000 ALTER TABLE `product_sku` DISABLE KEYS */;
INSERT INTO `product_sku` VALUES (1,1,'五花肉 500g','500g/份',NULL,32.80,36.00,26.00,0.500,'份',200,20,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,1,'五花肉 1000g','1000g/份',NULL,62.00,72.00,52.00,1.000,'份',120,20,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,2,'里脊肉 500g','500g/份',NULL,29.80,33.00,23.50,0.500,'份',150,20,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,3,'肋排 500g','500g/份',NULL,38.80,42.00,30.00,0.500,'份',100,10,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,4,'前腿肉 500g','500g/份(可分割)',NULL,25.80,29.00,20.00,0.500,'份',180,20,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(6,5,'肥牛卷 300g','300g/盒',NULL,28.80,32.00,21.00,0.300,'盒',300,30,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(7,6,'牛肉丸 250g','250g/袋',NULL,19.90,23.00,14.00,0.250,'袋',260,30,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(8,7,'火腿肠礼盒 8支','8支/盒',NULL,59.00,69.00,42.00,0.800,'盒',80,10,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(9,8,'牛油底料 400g','400g/袋',NULL,16.80,19.90,11.00,0.400,'袋',400,40,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10,9,'火锅到家套餐 3-4人','标准套',NULL,128.00,158.00,92.00,2.000,'套',60,10,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `product_sku` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_store`
--

DROP TABLE IF EXISTS `product_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_store` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `store_id` bigint NOT NULL,
  `stock` int NOT NULL DEFAULT '0' COMMENT '该门店库存',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '可售状态',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_store` (`product_id`,`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品-门店可售与库存';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_store`
--

LOCK TABLES `product_store` WRITE;
/*!40000 ALTER TABLE `product_store` DISABLE KEYS */;
INSERT INTO `product_store` VALUES (1,1,2,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,1,1,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,2,2,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,2,1,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,3,2,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(6,3,1,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(7,4,2,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(8,4,1,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(9,5,2,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10,5,1,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(11,6,2,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(12,6,1,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(13,7,2,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(14,7,1,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(15,8,2,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(16,8,1,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(17,9,2,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(18,9,1,100,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `product_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_item`
--

DROP TABLE IF EXISTS `purchase_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `purchase_id` bigint NOT NULL,
  `product_id` bigint DEFAULT NULL,
  `product_name` varchar(128) NOT NULL,
  `spec` varchar(128) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '供货单价',
  `quantity` decimal(12,3) NOT NULL DEFAULT '0.000',
  `unit` varchar(16) DEFAULT 'kg',
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_purchase` (`purchase_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='供货单明细';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_item`
--

LOCK TABLES `purchase_item` WRITE;
/*!40000 ALTER TABLE `purchase_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_order`
--

DROP TABLE IF EXISTS `purchase_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `purchase_no` varchar(64) NOT NULL COMMENT '供货单号',
  `supplier_id` bigint NOT NULL,
  `store_id` bigint NOT NULL,
  `total_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `settle_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '已结算金额',
  `status` varchar(20) NOT NULL DEFAULT 'CREATED' COMMENT 'CREATED待发货/DELIVERING配送中/RECEIVED已入库/CHECKING对账中/SETTLED已结算',
  `expect_date` date DEFAULT NULL COMMENT '期望到货',
  `receive_time` datetime DEFAULT NULL,
  `inventory_id` bigint DEFAULT NULL COMMENT '入库单',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_purchase_no` (`purchase_no`),
  KEY `idx_supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='供货单/采购单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order`
--

LOCK TABLES `purchase_order` WRITE;
/*!40000 ALTER TABLE `purchase_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_plan`
--

DROP TABLE IF EXISTS `purchase_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_no` varchar(64) NOT NULL,
  `store_id` bigint NOT NULL,
  `plan_date` date NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'DRAFT' COMMENT 'DRAFT草稿/SUBMITTED已提交/DONE已采购',
  `total_amount` decimal(12,2) DEFAULT '0.00',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plan_no` (`plan_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='采购计划';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_plan`
--

LOCK TABLES `purchase_plan` WRITE;
/*!40000 ALTER TABLE `purchase_plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refund_record`
--

DROP TABLE IF EXISTS `refund_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refund_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `refund_no` varchar(64) NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `order_no` varchar(64) DEFAULT NULL,
  `aftersale_id` bigint DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `refund_type` varchar(20) NOT NULL DEFAULT 'WECHAT' COMMENT 'WECHAT/BALANCE',
  `status` varchar(20) NOT NULL DEFAULT 'APPLYING' COMMENT 'APPLYING/SUCCESS/FAILED',
  `refund_time` datetime DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_refund_no` (`refund_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='退款记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refund_record`
--

LOCK TABLES `refund_record` WRITE;
/*!40000 ALTER TABLE `refund_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `refund_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserve_config`
--

DROP TABLE IF EXISTS `reserve_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserve_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `store_id` bigint NOT NULL,
  `reserve_days` int NOT NULL DEFAULT '2' COMMENT '可预订天数(当天/次日)',
  `cutoff_time` varchar(16) DEFAULT '18:00' COMMENT '当日预订截止时间',
  `split_fee_cube` decimal(10,2) DEFAULT '0.00' COMMENT '切块加工费',
  `split_fee_minced` decimal(10,2) DEFAULT '0.00' COMMENT '绞肉加工费',
  `split_fee_sliced` decimal(10,2) DEFAULT '0.00' COMMENT '切片加工费',
  `loss_rate` decimal(6,2) DEFAULT '3.00' COMMENT '分割损耗率(%)',
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_store` (`store_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='鲜肉预订配置(分割加工费/损耗率可配)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserve_config`
--

LOCK TABLES `reserve_config` WRITE;
/*!40000 ALTER TABLE `reserve_config` DISABLE KEYS */;
INSERT INTO `reserve_config` VALUES (1,1,2,'18:00',2.00,2.00,3.00,3.00,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,2,2,'18:00',2.00,2.00,3.00,3.00,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `reserve_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserve_stock`
--

DROP TABLE IF EXISTS `reserve_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserve_stock` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `store_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `sku_id` bigint DEFAULT NULL,
  `reserve_date` date NOT NULL COMMENT '预订日期',
  `capacity` int NOT NULL DEFAULT '0' COMMENT '备货量(份/斤)',
  `booked` int NOT NULL DEFAULT '0' COMMENT '已预订量',
  `version` int NOT NULL DEFAULT '0' COMMENT '乐观锁',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_store_prod_date` (`store_id`,`product_id`,`sku_id`,`reserve_date`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='鲜肉预订备货量(Redis锁防超卖)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserve_stock`
--

LOCK TABLES `reserve_stock` WRITE;
/*!40000 ALTER TABLE `reserve_stock` DISABLE KEYS */;
INSERT INTO `reserve_stock` VALUES (1,1,1,1,'2026-10-16',100,12,1,'2026-10-16 18:59:58','2026-10-16 21:16:20',0),(2,1,2,3,'2026-10-16',80,6,0,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,1,4,5,'2026-10-16',120,20,0,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `reserve_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '关联 sys_user',
  `store_id` bigint NOT NULL,
  `name` varchar(64) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `staff_type` varchar(20) NOT NULL DEFAULT 'CLERK' COMMENT 'CLERK店员/CUTTER分割师傅',
  `commission_rate` decimal(6,2) DEFAULT '2.00' COMMENT '提成比例(%)',
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_store` (`store_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='店员/分割师傅';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,4,1,'张店员','13800000003','CLERK',2.00,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,5,1,'赵师傅','13800000004','CUTTER',3.00,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_order`
--

DROP TABLE IF EXISTS `staff_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(64) NOT NULL COMMENT '称重开单号',
  `store_id` bigint NOT NULL,
  `staff_id` bigint NOT NULL,
  `member_id` bigint DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  `product_name` varchar(128) DEFAULT NULL,
  `weight` decimal(10,3) DEFAULT '0.000' COMMENT '实称重量(kg)',
  `price` decimal(10,2) DEFAULT '0.00',
  `amount` decimal(12,2) DEFAULT '0.00',
  `pay_type` varchar(20) DEFAULT 'CASH' COMMENT 'CASH/WECHAT/BALANCE',
  `commission` decimal(10,2) DEFAULT '0.00' COMMENT '提成',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_staff_order_no` (`order_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='称重开单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_order`
--

LOCK TABLES `staff_order` WRITE;
/*!40000 ALTER TABLE `staff_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_performance`
--

DROP TABLE IF EXISTS `staff_performance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_performance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `staff_id` bigint NOT NULL,
  `store_id` bigint NOT NULL,
  `stat_date` date NOT NULL,
  `order_count` int NOT NULL DEFAULT '0',
  `sales_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `split_count` int NOT NULL DEFAULT '0',
  `split_weight` decimal(12,3) NOT NULL DEFAULT '0.000',
  `commission` decimal(12,2) NOT NULL DEFAULT '0.00',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_staff_date` (`staff_id`,`stat_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='店员业绩/提成';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_performance`
--

LOCK TABLES `staff_performance` WRITE;
/*!40000 ALTER TABLE `staff_performance` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_performance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_split_record`
--

DROP TABLE IF EXISTS `staff_split_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_split_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `store_id` bigint NOT NULL,
  `staff_id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `order_no` varchar(64) DEFAULT NULL,
  `order_item_id` bigint DEFAULT NULL,
  `product_name` varchar(128) DEFAULT NULL,
  `split_type` varchar(20) NOT NULL COMMENT 'CUBE切块/MINCED绞肉/SLICED切片',
  `weight` decimal(10,3) DEFAULT '0.000' COMMENT '加工重量(kg)',
  `loss_weight` decimal(10,3) DEFAULT '0.000' COMMENT '损耗重量(kg)',
  `split_fee` decimal(10,2) DEFAULT '0.00' COMMENT '加工费',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_staff` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分割加工登记';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_split_record`
--

LOCK TABLES `staff_split_record` WRITE;
/*!40000 ALTER TABLE `staff_split_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_split_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_task`
--

DROP TABLE IF EXISTS `staff_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_task` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `store_id` bigint NOT NULL,
  `staff_id` bigint DEFAULT NULL,
  `order_id` bigint DEFAULT NULL,
  `order_no` varchar(64) DEFAULT NULL,
  `task_type` varchar(20) NOT NULL DEFAULT 'PREPARE' COMMENT 'PREPARE备货/SPLIT分割/PICK配货/DELIVER配送',
  `task_date` date DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING待办/DOING进行中/DONE已完成',
  `finish_time` datetime DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_store_date` (`store_id`,`task_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='店员备货/配货待办';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_task`
--

LOCK TABLES `staff_task` WRITE;
/*!40000 ALTER TABLE `staff_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store`
--

DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL COMMENT '门店编码',
  `name` varchar(128) NOT NULL COMMENT '门店名称',
  `manager_id` bigint DEFAULT NULL COMMENT '店长用户ID',
  `contact` varchar(64) DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `province` varchar(64) DEFAULT NULL,
  `city` varchar(64) DEFAULT NULL,
  `district` varchar(64) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL COMMENT '详细地址',
  `lng` decimal(10,6) DEFAULT NULL COMMENT '经度',
  `lat` decimal(10,6) DEFAULT NULL COMMENT '纬度',
  `business_hours` varchar(64) DEFAULT NULL COMMENT '营业时间 08:00-21:00',
  `delivery_radius_km` decimal(6,2) DEFAULT '3.00' COMMENT '配送半径(km)',
  `delivery_fee` decimal(10,2) DEFAULT '0.00' COMMENT '配送费',
  `free_delivery_amount` decimal(10,2) DEFAULT '0.00' COMMENT '满额免配送费',
  `min_order_amount` decimal(10,2) DEFAULT '0.00' COMMENT '起送金额',
  `images` varchar(1000) DEFAULT NULL COMMENT '门店图片(逗号分隔)',
  `intro` varchar(500) DEFAULT NULL COMMENT '门店简介',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1营业 0停业',
  `sort` int NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_store_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='门店(多门店)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store`
--

LOCK TABLES `store` WRITE;
/*!40000 ALTER TABLE `store` DISABLE KEYS */;
INSERT INTO `store` VALUES (1,'S001','猪事大吉·西城店',NULL,'王店长','13800000001','北京市','北京市','西城区','西城区某某路 1 号',116.366000,39.912000,'07:00-21:00',3.00,5.00,59.00,20.00,NULL,'社区鲜肉旗舰店，含分割加工台',1,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'S002','猪事大吉·朝阳店',NULL,'孙店长','13800000009','北京市','北京市','朝阳区','朝阳区某某路 88 号',116.486000,39.921000,'07:30-21:30',5.00,6.00,69.00,20.00,NULL,'火锅食材专区',1,2,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL COMMENT '供应商编码',
  `name` varchar(128) NOT NULL,
  `user_id` bigint DEFAULT NULL COMMENT '供应商端登录账号',
  `contact` varchar(64) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `supply_type` varchar(20) NOT NULL DEFAULT 'PORK' COMMENT 'PORK猪肉/HOTPOT火锅食材/PROCESSED肉制品/BASE底料',
  `settle_type` varchar(20) NOT NULL DEFAULT 'MONTH' COMMENT 'MONTH月结/WEEK周结/CASH现结',
  `bank_name` varchar(128) DEFAULT NULL,
  `bank_account` varchar(64) DEFAULT NULL,
  `bank_holder` varchar(64) DEFAULT NULL,
  `rating` decimal(3,1) DEFAULT '5.0' COMMENT '评级(1-5)',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1合作 0停用',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_supplier_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='供应商档案';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'GYS001','山东某某猪肉食品有限公司',7,'刘经理','13700000001','山东省临沂市某某路 9 号','PORK','MONTH','中国银行','6222000000000001','山东某某猪肉食品有限公司',4.8,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'GYS002','内蒙古某某牛羊肉有限公司',NULL,'赵经理','13700000002','内蒙古呼和浩特市某某街 8 号','HOTPOT','MONTH','工商银行','6222000000000002','内蒙古某某牛羊肉有限公司',4.5,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier_agreement`
--

DROP TABLE IF EXISTS `supplier_agreement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_agreement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `supplier_id` bigint NOT NULL,
  `agreement_no` varchar(64) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `file_url` varchar(500) DEFAULT NULL COMMENT '协议文件',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `settle_type` varchar(20) DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='供货协议';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_agreement`
--

LOCK TABLES `supplier_agreement` WRITE;
/*!40000 ALTER TABLE `supplier_agreement` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplier_agreement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier_delivery`
--

DROP TABLE IF EXISTS `supplier_delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_delivery` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `delivery_no` varchar(64) NOT NULL,
  `purchase_id` bigint NOT NULL,
  `supplier_id` bigint NOT NULL,
  `delivery_time` datetime DEFAULT NULL,
  `driver` varchar(64) DEFAULT NULL,
  `driver_phone` varchar(20) DEFAULT NULL,
  `cold_chain_temp` decimal(5,2) DEFAULT NULL COMMENT '冷链温度(℃)',
  `status` varchar(20) NOT NULL DEFAULT 'DELIVERING' COMMENT 'DELIVERING/RECEIVED',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_delivery_no` (`delivery_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='送货单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_delivery`
--

LOCK TABLES `supplier_delivery` WRITE;
/*!40000 ALTER TABLE `supplier_delivery` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplier_delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier_qualification`
--

DROP TABLE IF EXISTS `supplier_qualification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_qualification` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `supplier_id` bigint NOT NULL,
  `qual_type` varchar(20) NOT NULL COMMENT 'QUARANTINE检疫合格证/SC食品生产许可/BUSINESS营业执照/INSPECTION检测报告',
  `qual_no` varchar(128) DEFAULT NULL,
  `file_url` varchar(500) DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `expire_date` date DEFAULT NULL,
  `audit_status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/APPROVED/REJECTED',
  `audit_remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_supplier` (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='供应商资质/检疫证明(审核)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_qualification`
--

LOCK TABLES `supplier_qualification` WRITE;
/*!40000 ALTER TABLE `supplier_qualification` DISABLE KEYS */;
INSERT INTO `supplier_qualification` VALUES (1,1,'QUARANTINE','GYS-QT-2026-001',NULL,'2026-01-01','2026-12-31','APPROVED',NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,1,'BUSINESS','9137000000000000XA',NULL,'2020-03-01','2040-03-01','APPROVED',NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,2,'QUARANTINE','GYS-QT-2026-002',NULL,'2026-02-01','2027-01-31','PENDING',NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `supplier_qualification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier_settlement`
--

DROP TABLE IF EXISTS `supplier_settlement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_settlement` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `settle_no` varchar(64) NOT NULL,
  `supplier_id` bigint NOT NULL,
  `period_start` date DEFAULT NULL,
  `period_end` date DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '应付金额',
  `paid_amount` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '已付金额',
  `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING待对账/CONFIRMED已对账/PAID已付款',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_settle_no` (`settle_no`),
  KEY `idx_supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='供应商对账单/结算';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_settlement`
--

LOCK TABLES `supplier_settlement` WRITE;
/*!40000 ALTER TABLE `supplier_settlement` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplier_settlement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_audit_log`
--

DROP TABLE IF EXISTS `sys_audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_audit_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `username` varchar(64) DEFAULT NULL,
  `module` varchar(64) DEFAULT NULL COMMENT '模块',
  `action` varchar(64) DEFAULT NULL COMMENT '操作类型',
  `method` varchar(10) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `params` text,
  `result` text,
  `ip` varchar(64) DEFAULT NULL,
  `ua` varchar(500) DEFAULT NULL,
  `cost_ms` bigint DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '1成功 0失败',
  `error_msg` text,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='审计日志(仅查询,不可增删改)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_audit_log`
--

LOCK TABLES `sys_audit_log` WRITE;
/*!40000 ALTER TABLE `sys_audit_log` DISABLE KEYS */;
INSERT INTO `sys_audit_log` VALUES (1,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"},org.apache.catalina.connector.RequestFacade@2655ee8d','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJiMzg5NzEzZDE2ZDM0OTFmYTIxNWRlM2UzMmM2MzdhMSIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU1MjI4LCJleHAiOjE3OTIyNDE2Mjh9.ylIqEIXl-kd2eaX6Jua9A6Ks4BeBkqCKn8F2ACGGHnIWWIhtlO0cegzht6Nshidg\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792155228699,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',2719,1,NULL,'2026-10-16 20:53:49','2026-10-16 20:53:49',0),(2,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"},org.apache.catalina.connector.RequestFacade@423b409','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI0ODQwZTBiZWRmNzA0MmEzYmRiNDI0NTRhM2I5NzU1MSIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU1MjM5LCJleHAiOjE3OTIyNDE2Mzl9.VtPa1Gnt2M__HNUhA-pA1dvYwVQbFnuOASYlZVstSGSsFdLumYn8GrqwdzDYbB9O\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792155239888,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',97,1,NULL,'2026-10-16 20:54:00','2026-10-16 20:54:00',0),(3,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"},org.apache.catalina.connector.RequestFacade@482c2532','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIwMzVjMzBkNThhM2Y0ZmVkYTc0ZmUzNWFjMDEyZTYxMyIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU1MjQzLCJleHAiOjE3OTIyNDE2NDN9.cOc_9IiyATRlBnM9Aca1VhXFvoDgg6Ldh6YAkXnoGIdgpymH552r5m4BUvvfDE29\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792155243125,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',153,1,NULL,'2026-10-16 20:54:03','2026-10-16 20:54:03',0),(4,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"},org.apache.catalina.connector.RequestFacade@2039f84d','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkNGY1MTRmYjM0MWU0ZDRlOGJhNGM2MDY0MTgwNTM0NyIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU1MjQ0LCJleHAiOjE3OTIyNDE2NDR9.3-4DhMtjavYpzU-3jsApbwkfh9TOisH-cmSGNWuy40cfpAyFXCWRinYamXddWKRv\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792155244486,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',180,1,NULL,'2026-10-16 20:54:04','2026-10-16 20:54:04',0),(5,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"},org.apache.catalina.connector.RequestFacade@2a7f299b','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJkMzI1ZmExNjU0NTQ0NDM5YmIzMDUxNGVjZGE4MmRkMCIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU1MjU5LCJleHAiOjE3OTIyNDE2NTl9._5hHidjeQ9dAped8dACCB6y_YEXz5M42KRWB4dMwHmTewXU1E0Qrj-e8HMsOkcUF\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792155259910,\"success\":true}','127.0.0.1','node',89,1,NULL,'2026-10-16 20:54:20','2026-10-16 20:54:20',0),(6,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"}','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxMWUyNWY5ZjNlM2E0NGVlODQ3ZGJiYzEwY2M0NjFhZSIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU1NDM3LCJleHAiOjE3OTIyNDE4Mzd9.EQS7bZLhOQS3n-HTH64v0_5dGP5iobFbm2QtUyMXnxZIKs6lVye2DWg-4PChwU-8\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792155438171,\"success\":true}','127.0.0.1','node',2791,1,NULL,'2026-10-16 20:57:18','2026-10-16 20:57:18',0),(7,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"}','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4M2RkZDgzNDA3MGU0NGJmOWUyZWQxODk4ZjJmMGQwNCIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU1NDUzLCJleHAiOjE3OTIyNDE4NTN9.ialxzspUu_tAgdCd56XYRH_KuJBWP4ahU26r5phHtapJbrmRQmgZITiJhXs-Nulo\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792155453559,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',183,1,NULL,'2026-10-16 20:57:34','2026-10-16 20:57:34',0),(8,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"}','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxNDk2NjNmM2Q1Zjk0NmNiYjgzMDk5ZWU3YmM5MTIxNyIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU2Mzc2LCJleHAiOjE3OTIyNDI3NzZ9.7Mq8ex2A6cslsPoUlf4o9lKEo_ARxhAq3g1Twy91bumw9O7jYiLLqra5IxeoLLWc\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792156376392,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',1577,1,NULL,'2026-10-16 21:12:56','2026-10-16 21:12:56',0),(9,1,'admin','SysAuditLog','save','POST','/api/system/audit','{}',NULL,'127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',0,0,'审计日志不可新增','2026-10-16 21:12:57','2026-10-16 21:12:57',0),(10,1,'admin','菜单维护','拖拽排序','PUT','/api/system/menu/sort','[{\"id\":1,\"parentId\":0,\"sort\":1,\"children\":[]}]','{\"code\":200,\"msg\":\"排序已保存\",\"timestamp\":1792156377079,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',14,1,NULL,'2026-10-16 21:12:57','2026-10-16 21:12:57',0),(11,NULL,NULL,'门户订单','下单','POST','/api/public/orders','{\"memberId\":1,\"storeId\":1,\"orderType\":\"NORMAL\",\"source\":\"H5\",\"deliveryType\":\"DELIVERY\",\"receiverName\":\"张伟\",\"receiverPhone\":\"13900000001\",\"receiverAddress\":\"西城区\",\"items\":[{\"productId\":1,\"skuId\":1,\"productName\":\"精品五花肉\",\"skuName\":\"五花肉 500g\",\"price\":32.8,\"quantity\":2,\"splitType\":\"CUBE\",\"splitFee\":2}]}','{\"code\":200,\"msg\":\"下单成功\",\"data\":{\"id\":5,\"createTime\":\"2026-10-16T21:12:57.1278166\",\"updateTime\":\"2026-10-16T21:12:57.1278166\",\"orderNo\":\"ZS20261016000147\",\"memberId\":1,\"storeId\":1,\"orderType\":\"NORMAL\",\"source\":\"H5\",\"status\":\"UNPAID\",\"deliveryType\":\"DELIVERY\",\"receiverName\":\"张伟\",\"receiverPhone\":\"13900000001\",\"receiverAddress\":\"西城区\",\"totalAmount\":65.60,\"splitFee\":2,\"deliveryFee\":0,\"discountAmount\":0,\"payAmount\":67.60,\"payStatus\":\"UNPAID\"},\"timestamp\":1792156377150,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',48,1,NULL,'2026-10-16 21:12:57','2026-10-16 21:12:57',0),(12,NULL,NULL,'门户留言','提交','POST','/api/public/message','{\"id\":1,\"createTime\":\"2026-10-16T21:12:57.2731867\",\"updateTime\":\"2026-10-16T21:12:57.2731867\",\"msgType\":\"GROUP\",\"name\":\"测试企业\",\"phone\":\"13900000009\",\"company\":\"某某公司\",\"content\":\"团购咨询\",\"status\":\"UNREAD\"}','{\"code\":200,\"msg\":\"提交成功\",\"timestamp\":1792156377285,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',18,1,NULL,'2026-10-16 21:12:57','2026-10-16 21:12:57',0),(13,NULL,NULL,'门户会员','登录','POST','/api/public/login','{\"openid\":\"oTestSmoke001\",\"nickname\":\"冒烟用户\"}','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"id\":4,\"createTime\":\"2026-10-16T21:12:57\",\"updateTime\":\"2026-10-16T21:12:57\",\"openid\":\"oTestSmoke001\",\"nickname\":\"冒烟用户\",\"gender\":0,\"levelId\":1,\"balance\":0.00,\"points\":0,\"totalAmount\":0.00,\"status\":1},\"timestamp\":1792156377319,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT; Windows NT 10.0; zh-CN) WindowsPowerShell/5.1.19041.6456',19,1,NULL,'2026-10-16 21:12:57','2026-10-16 21:12:57',0),(14,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"}','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJlMDk1OTdjNzYwNDg0ZTczYWE4N2NkMmE1N2FiMzdjYiIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU2Mzg4LCJleHAiOjE3OTIyNDI3ODh9.iVkzNdHe5DUfEBNssOuM-w6c609LMop4ruRTdg-DIIyExyHQdfi5dioOZWwRsMDl\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792156388615,\"success\":true}','127.0.0.1','curl/8.13.0',170,1,NULL,'2026-10-16 21:13:09','2026-10-16 21:13:09',0),(15,1,'admin','SysAuditLog','save','POST','/api/system/audit','{}',NULL,'127.0.0.1','curl/8.13.0',0,0,'审计日志不可新增','2026-10-16 21:13:09','2026-10-16 21:13:09',0),(16,1,'admin','商品管理','新增商品','POST','/api/product/info','{\"id\":10,\"createTime\":\"2026-10-16T21:15:38.0814967\",\"updateTime\":\"2026-10-16T21:15:38.0814967\",\"categoryId\":101,\"name\":\"测试鲜肉\",\"subTitle\":\"级联保存测试\",\"bizType\":\"PORK\",\"unit\":\"斤\",\"reservable\":1,\"splitEnabled\":1,\"splitFee\":2,\"commissionRate\":5,\"settleType\":\"WEIGHT\",\"status\":0,\"skus\":[{\"id\":11,\"createTime\":\"2026-10-16T21:15:38.0985002\",\"updateTime\":\"2026-10-16T21:15:38.0985002\",\"productId\":10,\"skuName\":\"测试规格A\",\"spec\":\"500g\",\"price\":19.9,\"weight\":0.5,\"stock\":50,\"status\":1},{\"id\":12,\"createTime\":\"2026-10-16T21:15:38.102502\",\"updateTime\":\"2026-10-16T21:15:38.102502\",\"productId\":10,\"skuName\":\"测试规格B\",\"spec\":\"1000g\",\"price\":38.8,\"weight\":1,\"stock\":30,\"status\":1}],\"qualifications\":[{\"id\":4,\"createTime\":\"2026-10-16T21:15:38.1184317\",\"updateTime\":\"2026-10-16T21:15:38.1184317\",\"productId\":10,\"qualType\":\"QUARANTINE\",\"qualNo\":\"TEST-QA-001\",\"issuer\":\"测试机构\",\"status\":1}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":10,\"timestamp\":1792156538126,\"success\":true}','127.0.0.1','curl/8.13.0',51,1,NULL,'2026-10-16 21:15:38','2026-10-16 21:15:38',0),(17,1,'admin','商品管理','商品上下架','PUT','/api/product/info/10524/status','10524,1',NULL,'127.0.0.1','curl/8.13.0',4,0,'商品不存在','2026-10-16 21:15:39','2026-10-16 21:15:39',0),(18,1,'admin','商品管理','新增商品','POST','/api/product/info','{\"id\":11,\"createTime\":\"2026-10-16T21:15:38.9639402\",\"updateTime\":\"2026-10-16T21:15:38.9639402\",\"categoryId\":101,\"name\":\"无证鲜肉\",\"bizType\":\"PORK\",\"unit\":\"斤\",\"status\":0}','{\"code\":200,\"msg\":\"操作成功\",\"data\":11,\"timestamp\":1792156538974,\"success\":true}','127.0.0.1','curl/8.13.0',14,1,NULL,'2026-10-16 21:15:39','2026-10-16 21:15:39',0),(19,1,'admin','商品管理','商品上下架','PUT','/api/product/info/11/status','11,1',NULL,'127.0.0.1','curl/8.13.0',8,0,'鲜猪肉上架必须上传有效的检疫合格证明（两证两章）','2026-10-16 21:15:39','2026-10-16 21:15:39',0),(20,NULL,NULL,'Portal','booking','POST','/api/public/reserve/booking','{\"storeId\":1,\"productId\":1,\"skuId\":1,\"reserveDate\":\"2026-10-16\",\"quantity\":5}','{\"code\":200,\"msg\":\"预订成功\",\"timestamp\":1792156539485,\"success\":true}','127.0.0.1','curl/8.13.0',114,1,NULL,'2026-10-16 21:15:40','2026-10-16 21:15:40',0),(21,NULL,NULL,'Portal','booking','POST','/api/public/reserve/booking','{\"storeId\":1,\"productId\":1,\"skuId\":1,\"reserveDate\":\"2026-10-16\",\"quantity\":99999}',NULL,'127.0.0.1','curl/8.13.0',16,0,'备货量不足，无法预订','2026-10-16 21:15:40','2026-10-16 21:15:40',0),(22,1,'admin','渠道报单','审核','PUT','/api/channel/order/1/audit','1,\"APPROVED\",null','{\"code\":200,\"msg\":\"审核完成\",\"timestamp\":1792156540194,\"success\":true}','127.0.0.1','curl/8.13.0',22,1,NULL,'2026-10-16 21:15:40','2026-10-16 21:15:40',0),(23,1,'admin','角色管理','分配权限','PUT','/api/system/role/2/menus','2,[1,20,30,301,302]','{\"code\":200,\"msg\":\"权限分配成功\",\"timestamp\":1792156540489,\"success\":true}','127.0.0.1','curl/8.13.0',31,1,NULL,'2026-10-16 21:15:40','2026-10-16 21:15:40',0),(24,1,'admin','商品管理','新增商品','POST','/api/product/info','{\"id\":12,\"createTime\":\"2026-10-16T21:16:03.3582632\",\"updateTime\":\"2026-10-16T21:16:03.3592624\",\"categoryId\":101,\"name\":\"测试鲜肉\",\"subTitle\":\"级联保存测试\",\"bizType\":\"PORK\",\"unit\":\"斤\",\"reservable\":1,\"splitEnabled\":1,\"splitFee\":2,\"commissionRate\":5,\"settleType\":\"WEIGHT\",\"status\":0,\"skus\":[{\"id\":13,\"createTime\":\"2026-10-16T21:16:03.3682633\",\"updateTime\":\"2026-10-16T21:16:03.3682633\",\"productId\":12,\"skuName\":\"测试规格A\",\"spec\":\"500g\",\"price\":19.9,\"weight\":0.5,\"stock\":50,\"status\":1},{\"id\":14,\"createTime\":\"2026-10-16T21:16:03.3712681\",\"updateTime\":\"2026-10-16T21:16:03.3712681\",\"productId\":12,\"skuName\":\"测试规格B\",\"spec\":\"1000g\",\"price\":38.8,\"weight\":1,\"stock\":30,\"status\":1}],\"qualifications\":[{\"id\":5,\"createTime\":\"2026-10-16T21:16:03.3822632\",\"updateTime\":\"2026-10-16T21:16:03.3822632\",\"productId\":12,\"qualType\":\"QUARANTINE\",\"qualNo\":\"TEST-QA-001\",\"issuer\":\"测试机构\",\"status\":1}]}','{\"code\":200,\"msg\":\"操作成功\",\"data\":12,\"timestamp\":1792156563389,\"success\":true}','127.0.0.1','curl/8.13.0',36,1,NULL,'2026-10-16 21:16:03','2026-10-16 21:16:03',0),(25,1,'admin','商品管理','商品上下架','PUT','/api/product/info/12/status','12,1','{\"code\":200,\"msg\":\"操作成功\",\"timestamp\":1792156563687,\"success\":true}','127.0.0.1','curl/8.13.0',20,1,NULL,'2026-10-16 21:16:04','2026-10-16 21:16:04',0),(26,1,'admin','商品管理','新增商品','POST','/api/product/info','{\"id\":13,\"createTime\":\"2026-10-16T21:16:03.829102\",\"updateTime\":\"2026-10-16T21:16:03.8301007\",\"categoryId\":101,\"name\":\"无证鲜肉\",\"bizType\":\"PORK\",\"unit\":\"斤\",\"status\":0}','{\"code\":200,\"msg\":\"操作成功\",\"data\":13,\"timestamp\":1792156563837,\"success\":true}','127.0.0.1','curl/8.13.0',10,1,NULL,'2026-10-16 21:16:04','2026-10-16 21:16:04',0),(27,1,'admin','商品管理','商品上下架','PUT','/api/product/info/13/status','13,1',NULL,'127.0.0.1','curl/8.13.0',6,0,'鲜猪肉上架必须上传有效的检疫合格证明（两证两章）','2026-10-16 21:16:04','2026-10-16 21:16:04',0),(28,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"}','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI1YWVjOTE0ZDMyMTM0NjAyYTFlYmM3YTMxMmViNjhiZiIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU2NTg3LCJleHAiOjE3OTIyNDI5ODd9.bFzsPKKJkUnvtuSgtIB1nqoFUP_HtTtLGDI3YP8Kzt_XPr6MJZagSY9ZiG5T8hgv\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792156587882,\"success\":true}','127.0.0.1','curl/8.13.0',352,1,NULL,'2026-10-16 21:16:28','2026-10-16 21:16:28',0),(29,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"}','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI4MTg0YjkyZDc3NWU0ZmYyOTgwNzhhMjA4MzIzNTJiNCIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU3NDU0LCJleHAiOjE3OTIyNDM4NTR9.qOxFV1vSU7CJHTwvabnA4Xg3yt5603CPegG7QNVNVXT-B-EbaW8DEAFZrbJPMWMh\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792157454725,\"success\":true}','127.0.0.1','curl/8.13.0',1535,1,NULL,'2026-10-16 21:30:55','2026-10-16 21:30:55',0),(30,NULL,NULL,'认证','登录','POST','/api/auth/login','{\"username\":\"admin\",\"password\":\"admin123\"}','{\"code\":200,\"msg\":\"登录成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiI3YzdiYjNhZmM5M2Q0YjA4YmViMzFhNmNjOTc2M2VhZCIsInVzZXJJZCI6MSwiaWF0IjoxNzkyMTU3NTEzLCJleHAiOjE3OTIyNDM5MTN9.gEwyDkC0t92OHdeNWaB3PRUflVZrWmS_xfRO-KICOmsnfs7wqo5cHR20MA_XxcWm\",\"expiresIn\":86400,\"userInfo\":{\"userId\":1,\"username\":\"admin\",\"nickname\":\"超级管理员\",\"userType\":\"ADMIN\",\"superAdmin\":true,\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"roles\":[\"SUPER_ADMIN\"],\"perms\":[\"*:*:*\"]},\"timestamp\":1792157513117,\"success\":true}','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0',89,1,NULL,'2026-10-16 21:31:53','2026-10-16 21:31:53',0);
/*!40000 ALTER TABLE `sys_audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_code` varchar(64) NOT NULL COMMENT '分组 site/icp/service/wechat/pay/oss/delivery/commission/reserve',
  `group_name` varchar(64) DEFAULT NULL COMMENT '分组名称',
  `config_key` varchar(128) NOT NULL COMMENT '参数键',
  `config_name` varchar(128) NOT NULL COMMENT '参数名',
  `config_value` text COMMENT '参数值',
  `value_type` varchar(20) NOT NULL DEFAULT 'STRING' COMMENT 'STRING/NUMBER/BOOLEAN/JSON/IMAGE/TEXT',
  `encrypted` tinyint NOT NULL DEFAULT '0' COMMENT '是否加密存储',
  `sort` int NOT NULL DEFAULT '0',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统参数(可视化配置)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'site','站点信息','site.name','站点名称','猪事大吉','STRING',0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'site','站点信息','site.logo','站点 Logo','','IMAGE',0,2,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'site','站点信息','site.icp','ICP 备案号','','STRING',0,3,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,'site','站点信息','site.copyright','版权信息','© 猪事大吉','STRING',0,4,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,'site','站点信息','site.keywords','SEO 关键词','鲜肉,火锅食材,肉制品,猪肉,社区生鲜','STRING',0,5,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(6,'site','站点信息','site.description','SEO 描述','猪事大吉 · 社区一站式鲜肉与火锅食材超市','TEXT',0,6,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(7,'site','站点信息','site.service_phone','客服电话','400-000-0000','STRING',0,7,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(8,'site','站点信息','site.service_qrcode','客服二维码','','IMAGE',0,8,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(9,'wechat','微信配置','wechat.mp_appid','公众号 AppID','','STRING',0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10,'wechat','微信配置','wechat.mp_secret','公众号 AppSecret','','STRING',1,2,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(11,'wechat','微信配置','wechat.mpp_appid','小程序 AppID','','STRING',0,3,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(12,'wechat','微信配置','wechat.mpp_secret','小程序 AppSecret','','STRING',1,4,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(13,'wechat','微信配置','wechat.pay_mchid','微信支付商户号','','STRING',0,5,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(14,'wechat','微信配置','wechat.pay_apiv3_key','微信支付 APIv3 密钥','','STRING',1,6,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(15,'wechat','微信配置','wechat.pay_cert_path','微信支付证书路径','','STRING',1,7,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(16,'pay','支付配置','pay.expire_minutes','订单支付超时(分钟)','30','NUMBER',0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(17,'pay','支付配置','pay.auto_refund','取消订单自动退款','true','BOOLEAN',0,2,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(18,'delivery','配送配置','delivery.default_fee','默认配送费(元)','5.00','NUMBER',0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(19,'delivery','配送配置','delivery.free_amount','满额免配送费(元)','59.00','NUMBER',0,2,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(20,'delivery','配送配置','delivery.radius_km','默认配送半径(km)','3.00','NUMBER',0,3,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(21,'delivery','配送配置','delivery.min_order_amount','起送金额(元)','20.00','NUMBER',0,4,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(22,'commission','佣金提成','commission.channel_rate','渠道默认佣金比例(%)','8.00','NUMBER',0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(23,'commission','佣金提成','commission.channel_level2_rate','二级渠道佣金比例(%)','3.00','NUMBER',0,2,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(24,'commission','佣金提成','commission.staff_rate','店员默认提成比例(%)','2.00','NUMBER',0,3,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(25,'reserve','鲜肉预订','reserve.days','可预订天数','2','NUMBER',0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(26,'reserve','鲜肉预订','reserve.cutoff_time','当日预订截止时间','18:00','STRING',0,2,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(27,'reserve','鲜肉预订','reserve.split_fee_cube','切块加工费(元)','2.00','NUMBER',0,3,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(28,'reserve','鲜肉预订','reserve.split_fee_minced','绞肉加工费(元)','2.00','NUMBER',0,4,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(29,'reserve','鲜肉预订','reserve.split_fee_sliced','切片加工费(元)','3.00','NUMBER',0,5,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30,'reserve','鲜肉预订','reserve.loss_rate','分割损耗率(%)','3.00','NUMBER',0,6,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(31,'sms','短信配置','sms.driver','短信服务商','aliyun','STRING',0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(32,'sms','短信配置','sms.sign','短信签名','猪事大吉','STRING',0,2,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(33,'sms','短信配置','sms.access_key','AccessKey','','STRING',1,3,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(34,'sms','短信配置','sms.access_secret','AccessSecret','','STRING',1,4,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(35,'oss','对象存储','oss.driver','当前驱动','LOCAL','STRING',0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(36,'oss','对象存储','oss.url_prefix','访问域名前缀','','STRING',0,2,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dict_code` varchar(64) NOT NULL COMMENT '字典编码',
  `label` varchar(64) NOT NULL COMMENT '显示值',
  `label_en` varchar(64) DEFAULT NULL COMMENT '英文显示值',
  `value` varchar(64) NOT NULL COMMENT '数据值',
  `sort` int NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_dict_code` (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,'biz_type','鲜猪肉','Pork','PORK',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'biz_type','火锅食材','Hotpot','HOTPOT',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'biz_type','肉制品','Processed','PROCESSED',3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,'biz_type','火锅底料蘸料','Base & Sauce','BASE',4,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,'biz_type','套餐礼盒','Combo & Gift','SET',5,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(6,'order_status','待支付','Unpaid','UNPAID',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(7,'order_status','待备货','Preparing','PREPARING',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(8,'order_status','待取货','Ready','READY',3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(9,'order_status','配送中','Delivering','DELIVERING',4,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10,'order_status','已完成','Completed','COMPLETED',5,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(11,'order_status','已取消','Cancelled','CANCELLED',6,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(12,'order_status','售后','Aftersale','AFTERSALE',7,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(13,'order_type','普通订单','Normal','NORMAL',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(14,'order_type','鲜肉预订','Reserve','RESERVE',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(15,'order_type','火锅套餐','Hotpot Set','SET',3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(16,'order_type','肉制品礼盒','Gift Box','GIFT',4,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(17,'delivery_type','到店自提','Self Pickup','SELF_PICKUP',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(18,'delivery_type','门店配送','Delivery','DELIVERY',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(19,'split_type','切块','Cubed','CUBE',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(20,'split_type','绞肉','Minced','MINCED',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(21,'split_type','切片','Sliced','SLICED',3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(22,'split_type','不分割','None','NONE',4,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(23,'qual_type','动物产品检疫合格证明','Quarantine Cert','QUARANTINE',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(24,'qual_type','肉品品质检验合格证','Quality Cert','QUALITY',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(25,'qual_type','食品生产许可(SC)','SC License','SC',3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(26,'qual_type','检测报告','Inspection Report','INSPECTION',4,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(27,'qual_type','营业执照','Business License','BUSINESS',5,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(28,'pay_type','微信支付','WeChat Pay','WECHAT',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(29,'pay_type','余额支付','Balance','BALANCE',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30,'pay_type','现金','Cash','CASH',3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(31,'settle_type','月结','Monthly','MONTH',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(32,'settle_type','周结','Weekly','WEEK',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(33,'settle_type','现结','Cash','CASH',3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(34,'settle_type','按重量','By Weight','WEIGHT',4,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(35,'settle_type','按份','By Unit','FIXED',5,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(36,'staff_type','店员','Clerk','CLERK',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(37,'staff_type','分割师傅','Cutter','CUTTER',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(38,'channel_type','团购','Group Buy','GROUP',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(39,'channel_type','分销','Distributor','DISTRIBUTOR',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(40,'channel_type','加盟','Franchise','FRANCHISE',3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(41,'yes_no','是','Yes','1',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(42,'yes_no','否','No','0',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(43,'audit_status','待审核','Pending','PENDING',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(44,'audit_status','已通过','Approved','APPROVED',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(45,'audit_status','已驳回','Rejected','REJECTED',3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL COMMENT '字典编码',
  `name` varchar(64) NOT NULL COMMENT '字典名称',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT '1',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dict_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'biz_type','商品品类',1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'order_status','订单状态',2,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'order_type','订单类型',3,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,'delivery_type','收货方式',4,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,'split_type','分割选项',5,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(6,'qual_type','资质类型',6,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(7,'pay_type','支付方式',7,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(8,'settle_type','结算方式',8,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(9,'staff_type','店员类型',9,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10,'channel_type','渠道类型',10,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(11,'yes_no','是否',11,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(12,'audit_status','审核状态',12,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_i18n`
--

DROP TABLE IF EXISTS `sys_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_i18n` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `lang_code` varchar(20) NOT NULL,
  `module` varchar(32) NOT NULL DEFAULT 'common' COMMENT '模块',
  `i18n_key` varchar(128) NOT NULL COMMENT '词条 key',
  `i18n_value` text COMMENT '词条值',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_lang_key` (`lang_code`,`module`,`i18n_key`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='多语言词条';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_i18n`
--

LOCK TABLES `sys_i18n` WRITE;
/*!40000 ALTER TABLE `sys_i18n` DISABLE KEYS */;
INSERT INTO `sys_i18n` VALUES (1,'zh-CN','common','app.name','猪事大吉','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'en-US','common','app.name','ZhuShi DaJi','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'zh-CN','common','app.slogan','社区鲜肉 · 火锅食材 · 肉制品','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,'en-US','common','app.slogan','Fresh Meat · Hotpot · Processed Meat','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,'zh-CN','common','action.add','新增','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(6,'en-US','common','action.add','Add','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(7,'zh-CN','common','action.edit','编辑','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(8,'en-US','common','action.edit','Edit','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(9,'zh-CN','common','action.delete','删除','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10,'en-US','common','action.delete','Delete','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(11,'zh-CN','common','action.search','查询','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(12,'en-US','common','action.search','Search','2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `sys_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_lang`
--

DROP TABLE IF EXISTS `sys_lang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_lang` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT '语言编码 zh-CN/en-US',
  `name` varchar(32) NOT NULL,
  `is_default` tinyint NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1',
  `sort` int NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_lang_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='语言维护';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_lang`
--

LOCK TABLES `sys_lang` WRITE;
/*!40000 ALTER TABLE `sys_lang` DISABLE KEYS */;
INSERT INTO `sys_lang` VALUES (1,'zh-CN','简体中文',1,1,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'en-US','English',0,1,2,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `sys_lang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父级ID',
  `platform` varchar(20) NOT NULL DEFAULT 'ADMIN' COMMENT '平台 ADMIN/PC/WECHAT/MINIAPP/H5',
  `menu_type` varchar(20) NOT NULL DEFAULT 'MENU' COMMENT 'DIR目录/MENU菜单/BUTTON按钮/LINK外链',
  `name` varchar(64) NOT NULL COMMENT '菜单名称',
  `name_en` varchar(64) DEFAULT NULL COMMENT '英文名称(i18n)',
  `path` varchar(128) DEFAULT NULL COMMENT '路由地址/链接',
  `component` varchar(128) DEFAULT NULL COMMENT '组件路径',
  `icon` varchar(64) DEFAULT NULL COMMENT '图标',
  `perm` varchar(128) DEFAULT NULL COMMENT '权限标识 product:sku:list',
  `link_url` varchar(255) DEFAULT NULL COMMENT '外链 URL',
  `link_type` varchar(20) DEFAULT NULL COMMENT 'PAGE/PAGEVIEW/MINIAPP/WEBVIEW 公众号菜单类型',
  `appid` varchar(64) DEFAULT NULL COMMENT '公众号菜单跳转 appid',
  `page_path` varchar(255) DEFAULT NULL COMMENT '小程序页面路径',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序(拖拽维护)',
  `visible` tinyint NOT NULL DEFAULT '1' COMMENT '是否显示',
  `keep_alive` tinyint NOT NULL DEFAULT '1' COMMENT '是否缓存',
  `status` tinyint NOT NULL DEFAULT '1',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_parent` (`parent_id`),
  KEY `idx_platform` (`platform`)
) ENGINE=InnoDB AUTO_INCREMENT=110106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单表(后台/官网/公众号/小程序 tabBar/H5 五套,可增删改+拖拽排序)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,0,'ADMIN','MENU','工作台','Dashboard','/dashboard','dashboard/index','ep:home-filled','dashboard:view',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 21:12:57',0),(10,0,'ADMIN','DIR','系统管理','System','/system',NULL,'ep:setting','',NULL,NULL,NULL,NULL,10,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(20,0,'ADMIN','MENU','门店管理','Stores','/store/list','store/index','ep:shop','store:info:list',NULL,NULL,NULL,NULL,20,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30,0,'ADMIN','DIR','商品管理','Product','/product',NULL,'ep:goods','',NULL,NULL,NULL,NULL,30,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(40,0,'ADMIN','DIR','鲜肉预订','Reserve','/reserve',NULL,'ep:timer','',NULL,NULL,NULL,NULL,40,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(50,0,'ADMIN','DIR','订单中心','Order','/order',NULL,'ep:tickets','',NULL,NULL,NULL,NULL,50,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(60,0,'ADMIN','DIR','会员营销','Member','/member',NULL,'ep:user-filled','',NULL,NULL,NULL,NULL,60,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70,0,'ADMIN','DIR','供应商管理','Supplier','/supplier',NULL,'ep:truck','',NULL,NULL,NULL,NULL,70,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(80,0,'ADMIN','DIR','渠道商管理','Channel','/channel',NULL,'ep:share','',NULL,NULL,NULL,NULL,80,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90,0,'ADMIN','DIR','店员管理','Staff','/staff',NULL,'ep:user','',NULL,NULL,NULL,NULL,90,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(100,0,'ADMIN','DIR','官网 CMS','CMS','/cms',NULL,'ep:collection','',NULL,NULL,NULL,NULL,100,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(101,10,'ADMIN','MENU','用户管理','Users','/system/user','system/user/index','ep:user','sys:user:list',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(102,10,'ADMIN','MENU','角色管理','Roles','/system/role','system/role/index','ep:avatar','sys:role:list',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(103,10,'ADMIN','MENU','菜单维护','Menus','/system/menu','system/menu/index','ep:menu','sys:menu:list',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(104,10,'ADMIN','MENU','系统参数','Config','/system/config','system/config/index','ep:tools','sys:config:list',NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(105,10,'ADMIN','MENU','数据字典','Dict','/system/dict','system/dict/index','ep:notebook','sys:dict:list',NULL,NULL,NULL,NULL,5,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(106,10,'ADMIN','MENU','多语言','I18n','/system/i18n','system/i18n/index','ep:chat-dot-square','sys:i18n:list',NULL,NULL,NULL,NULL,6,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(107,10,'ADMIN','MENU','审计日志','AuditLog','/system/audit','system/audit/index','ep:document','sys:audit:list',NULL,NULL,NULL,NULL,7,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(108,10,'ADMIN','MENU','对象存储','ObjectStorage','/system/oss','system/oss/index','ep:files','oss:config:list',NULL,NULL,NULL,NULL,8,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(110,0,'ADMIN','DIR','微信管理','WeChat','/wechat',NULL,'ep:chat-line-round','',NULL,NULL,NULL,NULL,110,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(120,0,'ADMIN','MENU','数据看板','Analysis','/analysis','analysis/index','ep:data-analysis','analysis:view',NULL,NULL,NULL,NULL,120,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(301,30,'ADMIN','MENU','商品分类','Categories','/product/category','product/category/index','ep:grid','product:category:list',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(302,30,'ADMIN','MENU','商品列表','Products','/product/list','product/index','ep:dish','product:info:list',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(303,30,'ADMIN','MENU','检疫资质','Qualifications','/product/qualification','product/qualification/index','ep:stamp','product:qualification:list',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(401,40,'ADMIN','MENU','预订单','ReserveOrders','/reserve/order','reserve/order/index','ep:list','reserve:order:list',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(402,40,'ADMIN','MENU','备货量','ReserveStock','/reserve/stock','reserve/stock/index','ep:box','reserve:stock:list',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(403,40,'ADMIN','MENU','预订配置','ReserveConfig','/reserve/config','reserve/config/index','ep:set-up','reserve:config:list',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(501,50,'ADMIN','MENU','订单管理','Orders','/order/list','order/index','ep:document-copy','order:info:list',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(502,50,'ADMIN','MENU','售后管理','Aftersale','/order/aftersale','order/aftersale/index','ep:refresh-left','order:aftersale:list',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(601,60,'ADMIN','MENU','会员管理','Members','/member/list','member/index','ep:star','member:info:list',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(602,60,'ADMIN','MENU','会员等级','Levels','/member/level','member/level/index','ep:medal','member:level:list',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(603,60,'ADMIN','MENU','优惠券','Coupons','/member/coupon','member/coupon/index','ep:discount','member:coupon:list',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(604,60,'ADMIN','MENU','储值记录','BalanceLogs','/member/balance','member/balance/index','ep:wallet','member:balance:list',NULL,NULL,NULL,NULL,4,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(605,60,'ADMIN','MENU','积分记录','PointsLogs','/member/points','member/points/index','ep:coin','member:points:list',NULL,NULL,NULL,NULL,5,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(701,70,'ADMIN','MENU','供应商档案','Suppliers','/supplier/list','supplier/index','ep:office-building','supplier:info:list',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(702,70,'ADMIN','MENU','供货协议','Agreements','/supplier/agreement','supplier/agreement/index','ep:document-checked','supplier:agreement:list',NULL,NULL,NULL,NULL,2,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(703,70,'ADMIN','MENU','资质审核','Qualifications','/supplier/qualification','supplier/qualification/index','ep:stamp','supplier:qualification:list',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(704,70,'ADMIN','MENU','采购计划','Plans','/supplier/plan','supplier/plan/index','ep:calendar','purchase:plan:list',NULL,NULL,NULL,NULL,4,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(705,70,'ADMIN','MENU','供货单','Purchases','/supplier/purchase','supplier/purchase/index','ep:shopping-cart','purchase:order:list',NULL,NULL,NULL,NULL,5,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(706,70,'ADMIN','MENU','送货单','Deliveries','/supplier/delivery','supplier/delivery/index','ep:van','supplier:delivery:list',NULL,NULL,NULL,NULL,6,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(707,70,'ADMIN','MENU','对账结算','Settlement','/supplier/settlement','supplier/settlement/index','ep:money','supplier:settlement:list',NULL,NULL,NULL,NULL,7,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(708,70,'ADMIN','MENU','库存预警','Warning','/supplier/warning','supplier/warning/index','ep:warning','inventory:warning:list',NULL,NULL,NULL,NULL,8,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(709,70,'ADMIN','MENU','出入库','Inventory','/supplier/inventory','supplier/inventory/index','ep:files','inventory:record:list',NULL,NULL,NULL,NULL,9,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(801,80,'ADMIN','MENU','渠道档案','Channels','/channel/list','channel/index','ep:connection','channel:info:list',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(802,80,'ADMIN','MENU','佣金规则','CommissionRules','/channel/rule','channel/rule/index','ep:coin','channel:rule:list',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(803,80,'ADMIN','MENU','报单审核','ChannelOrders','/channel/order','channel/order/index','ep:edit-pen','channel:order:list',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(804,80,'ADMIN','MENU','渠道结算','ChannelSettlement','/channel/settlement','channel/settlement/index','ep:money','channel:settlement:list',NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(805,80,'ADMIN','MENU','渠道专属价','ChannelPrice','/channel/price','channel/price/index','ep:price-tag','channel:price:list',NULL,NULL,NULL,NULL,5,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(901,90,'ADMIN','MENU','店员档案','Staffs','/staff/list','staff/index','ep:postcard','staff:info:list',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(902,90,'ADMIN','MENU','备货待办','Tasks','/staff/task','staff/task/index','ep:finished','staff:task:list',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(903,90,'ADMIN','MENU','分割登记','SplitRecords','/staff/split','staff/split/index','ep:scissor','staff:split:list',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(904,90,'ADMIN','MENU','称重开单','StaffOrders','/staff/order','staff/order/index','ep:scale-to-original','staff:order:list',NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(905,90,'ADMIN','MENU','业绩提成','Performance','/staff/performance','staff/performance/index','ep:trend-charts','staff:performance:list',NULL,NULL,NULL,NULL,5,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(1001,100,'ADMIN','MENU','栏目管理','Categories','/cms/category','cms/category/index','ep:folder','cms:category:list',NULL,NULL,NULL,NULL,1,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(1002,100,'ADMIN','MENU','文章资讯','Articles','/cms/article','cms/article/index','ep:reading','cms:article:list',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(1003,100,'ADMIN','MENU','Banner','Banners','/cms/banner','cms/banner/index','ep:picture','cms:banner:list',NULL,NULL,NULL,NULL,3,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(1004,100,'ADMIN','MENU','留言管理','Messages','/cms/message','cms/message/index','ep:message','cms:message:list',NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(1101,110,'ADMIN','MENU','公众号菜单','MP Menus','/wechat/menu','wechat/menu/index','ep:menu','wechat:menu:list',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(1102,110,'ADMIN','MENU','模板消息','Templates','/wechat/template','wechat/template/index','ep:bell','wechat:template:list',NULL,NULL,NULL,NULL,2,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(1103,110,'ADMIN','MENU','发送日志','Msg Logs','/wechat/log','wechat/log/index','ep:document','wechat:log:list',NULL,NULL,NULL,NULL,3,1,0,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2001,20,'ADMIN','BUTTON','门店新增',NULL,NULL,NULL,NULL,'store:info:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2002,20,'ADMIN','BUTTON','门店编辑',NULL,NULL,NULL,NULL,'store:info:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2003,20,'ADMIN','BUTTON','门店删除',NULL,NULL,NULL,NULL,'store:info:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10101,101,'ADMIN','BUTTON','用户新增',NULL,NULL,NULL,NULL,'sys:user:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10102,101,'ADMIN','BUTTON','用户编辑',NULL,NULL,NULL,NULL,'sys:user:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10103,101,'ADMIN','BUTTON','用户删除',NULL,NULL,NULL,NULL,'sys:user:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10104,101,'ADMIN','BUTTON','重置密码',NULL,NULL,NULL,NULL,'sys:user:resetPwd',NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10201,102,'ADMIN','BUTTON','角色新增',NULL,NULL,NULL,NULL,'sys:role:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10202,102,'ADMIN','BUTTON','角色编辑',NULL,NULL,NULL,NULL,'sys:role:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10203,102,'ADMIN','BUTTON','角色删除',NULL,NULL,NULL,NULL,'sys:role:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10204,102,'ADMIN','BUTTON','分配权限',NULL,NULL,NULL,NULL,'sys:role:assign',NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10301,103,'ADMIN','BUTTON','菜单新增',NULL,NULL,NULL,NULL,'sys:menu:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10302,103,'ADMIN','BUTTON','菜单编辑',NULL,NULL,NULL,NULL,'sys:menu:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10303,103,'ADMIN','BUTTON','菜单删除',NULL,NULL,NULL,NULL,'sys:menu:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10304,103,'ADMIN','BUTTON','拖拽排序',NULL,NULL,NULL,NULL,'sys:menu:sort',NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10401,104,'ADMIN','BUTTON','参数新增',NULL,NULL,NULL,NULL,'sys:config:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10402,104,'ADMIN','BUTTON','参数编辑',NULL,NULL,NULL,NULL,'sys:config:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10403,104,'ADMIN','BUTTON','参数删除',NULL,NULL,NULL,NULL,'sys:config:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10501,105,'ADMIN','BUTTON','字典新增',NULL,NULL,NULL,NULL,'sys:dict:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10502,105,'ADMIN','BUTTON','字典编辑',NULL,NULL,NULL,NULL,'sys:dict:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10503,105,'ADMIN','BUTTON','字典删除',NULL,NULL,NULL,NULL,'sys:dict:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10601,106,'ADMIN','BUTTON','词条新增',NULL,NULL,NULL,NULL,'sys:i18n:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10602,106,'ADMIN','BUTTON','词条编辑',NULL,NULL,NULL,NULL,'sys:i18n:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10603,106,'ADMIN','BUTTON','词条删除',NULL,NULL,NULL,NULL,'sys:i18n:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10801,108,'ADMIN','BUTTON','保存配置',NULL,NULL,NULL,NULL,'oss:config:edit',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(10802,108,'ADMIN','BUTTON','连接测试',NULL,NULL,NULL,NULL,'oss:config:test',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30101,301,'ADMIN','BUTTON','分类新增',NULL,NULL,NULL,NULL,'product:category:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30102,301,'ADMIN','BUTTON','分类编辑',NULL,NULL,NULL,NULL,'product:category:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30103,301,'ADMIN','BUTTON','分类删除',NULL,NULL,NULL,NULL,'product:category:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30201,302,'ADMIN','BUTTON','商品新增',NULL,NULL,NULL,NULL,'product:info:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30202,302,'ADMIN','BUTTON','商品编辑',NULL,NULL,NULL,NULL,'product:info:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30203,302,'ADMIN','BUTTON','商品删除',NULL,NULL,NULL,NULL,'product:info:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30204,302,'ADMIN','BUTTON','商品审核',NULL,NULL,NULL,NULL,'product:info:audit',NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30205,302,'ADMIN','BUTTON','上下架',NULL,NULL,NULL,NULL,'product:info:status',NULL,NULL,NULL,NULL,5,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30301,303,'ADMIN','BUTTON','资质新增',NULL,NULL,NULL,NULL,'product:qualification:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30302,303,'ADMIN','BUTTON','资质编辑',NULL,NULL,NULL,NULL,'product:qualification:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(30303,303,'ADMIN','BUTTON','资质删除',NULL,NULL,NULL,NULL,'product:qualification:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(40101,401,'ADMIN','BUTTON','订单备货',NULL,NULL,NULL,NULL,'reserve:order:prepare',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(40102,401,'ADMIN','BUTTON','订单取消',NULL,NULL,NULL,NULL,'reserve:order:cancel',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(40201,402,'ADMIN','BUTTON','设置备货量',NULL,NULL,NULL,NULL,'reserve:stock:edit',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(40301,403,'ADMIN','BUTTON','配置编辑',NULL,NULL,NULL,NULL,'reserve:config:edit',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(50101,501,'ADMIN','BUTTON','订单发货',NULL,NULL,NULL,NULL,'order:info:deliver',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(50102,501,'ADMIN','BUTTON','订单完成',NULL,NULL,NULL,NULL,'order:info:finish',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(50103,501,'ADMIN','BUTTON','订单取消',NULL,NULL,NULL,NULL,'order:info:cancel',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(50104,501,'ADMIN','BUTTON','订单导出',NULL,NULL,NULL,NULL,'order:info:export',NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(50201,502,'ADMIN','BUTTON','售后审核',NULL,NULL,NULL,NULL,'order:aftersale:audit',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(50202,502,'ADMIN','BUTTON','发起退款',NULL,NULL,NULL,NULL,'order:aftersale:refund',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(60101,601,'ADMIN','BUTTON','会员编辑',NULL,NULL,NULL,NULL,'member:info:edit',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(60102,601,'ADMIN','BUTTON','会员充值',NULL,NULL,NULL,NULL,'member:info:recharge',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(60103,601,'ADMIN','BUTTON','积分调整',NULL,NULL,NULL,NULL,'member:info:points',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(60201,602,'ADMIN','BUTTON','等级新增',NULL,NULL,NULL,NULL,'member:level:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(60202,602,'ADMIN','BUTTON','等级编辑',NULL,NULL,NULL,NULL,'member:level:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(60203,602,'ADMIN','BUTTON','等级删除',NULL,NULL,NULL,NULL,'member:level:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(60301,603,'ADMIN','BUTTON','券新增',NULL,NULL,NULL,NULL,'member:coupon:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(60302,603,'ADMIN','BUTTON','券编辑',NULL,NULL,NULL,NULL,'member:coupon:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(60303,603,'ADMIN','BUTTON','券删除',NULL,NULL,NULL,NULL,'member:coupon:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70101,701,'ADMIN','BUTTON','供应商新增',NULL,NULL,NULL,NULL,'supplier:info:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70102,701,'ADMIN','BUTTON','供应商编辑',NULL,NULL,NULL,NULL,'supplier:info:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70103,701,'ADMIN','BUTTON','供应商删除',NULL,NULL,NULL,NULL,'supplier:info:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70201,702,'ADMIN','BUTTON','协议新增',NULL,NULL,NULL,NULL,'supplier:agreement:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70202,702,'ADMIN','BUTTON','协议编辑',NULL,NULL,NULL,NULL,'supplier:agreement:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70301,703,'ADMIN','BUTTON','资质审核',NULL,NULL,NULL,NULL,'supplier:qualification:audit',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70401,704,'ADMIN','BUTTON','计划生成',NULL,NULL,NULL,NULL,'purchase:plan:generate',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70501,705,'ADMIN','BUTTON','供货单新增',NULL,NULL,NULL,NULL,'purchase:order:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70502,705,'ADMIN','BUTTON','供货单编辑',NULL,NULL,NULL,NULL,'purchase:order:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70503,705,'ADMIN','BUTTON','入库',NULL,NULL,NULL,NULL,'purchase:order:receive',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70701,707,'ADMIN','BUTTON','生成对账单',NULL,NULL,NULL,NULL,'supplier:settlement:generate',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70702,707,'ADMIN','BUTTON','确认结算',NULL,NULL,NULL,NULL,'supplier:settlement:confirm',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(70801,708,'ADMIN','BUTTON','处理预警',NULL,NULL,NULL,NULL,'inventory:warning:handle',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(80101,801,'ADMIN','BUTTON','渠道新增',NULL,NULL,NULL,NULL,'channel:info:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(80102,801,'ADMIN','BUTTON','渠道编辑',NULL,NULL,NULL,NULL,'channel:info:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(80103,801,'ADMIN','BUTTON','渠道删除',NULL,NULL,NULL,NULL,'channel:info:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(80201,802,'ADMIN','BUTTON','规则新增',NULL,NULL,NULL,NULL,'channel:rule:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(80202,802,'ADMIN','BUTTON','规则编辑',NULL,NULL,NULL,NULL,'channel:rule:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(80203,802,'ADMIN','BUTTON','规则删除',NULL,NULL,NULL,NULL,'channel:rule:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(80301,803,'ADMIN','BUTTON','报单审核',NULL,NULL,NULL,NULL,'channel:order:audit',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(80401,804,'ADMIN','BUTTON','生成结算单',NULL,NULL,NULL,NULL,'channel:settlement:generate',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(80402,804,'ADMIN','BUTTON','确认打款',NULL,NULL,NULL,NULL,'channel:settlement:pay',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90001,0,'PC','LINK','首页','Home','/',NULL,'',NULL,NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90002,0,'PC','LINK','品牌故事','Brand','/brand',NULL,'',NULL,NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90003,0,'PC','LINK','产品展示','Products','/products',NULL,'',NULL,NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90004,0,'PC','LINK','门店导航','Stores','/stores',NULL,'',NULL,NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90005,0,'PC','LINK','新闻资讯','News','/news',NULL,'',NULL,NULL,NULL,NULL,NULL,5,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90006,0,'PC','LINK','联系我们','Contact','/contact',NULL,'',NULL,NULL,NULL,NULL,NULL,6,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90101,901,'ADMIN','BUTTON','店员新增',NULL,NULL,NULL,NULL,'staff:info:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90102,901,'ADMIN','BUTTON','店员编辑',NULL,NULL,NULL,NULL,'staff:info:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90103,901,'ADMIN','BUTTON','店员删除',NULL,NULL,NULL,NULL,'staff:info:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90201,902,'ADMIN','BUTTON','派单',NULL,NULL,NULL,NULL,'staff:task:assign',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90301,903,'ADMIN','BUTTON','分割登记',NULL,NULL,NULL,NULL,'staff:split:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(90401,904,'ADMIN','BUTTON','称重开单',NULL,NULL,NULL,NULL,'staff:order:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(91001,0,'WECHAT','MENU','品牌故事','Brand','',NULL,'',NULL,NULL,'PAGE',NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(91002,0,'WECHAT','MENU','门店导航','Stores','',NULL,'',NULL,NULL,'PAGE',NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(91003,0,'WECHAT','MENU','进入商城','Mall','',NULL,'',NULL,NULL,'MINIAPP',NULL,'pages/index/index',3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(91011,91001,'WECHAT','MENU','猪事大吉的故事','Our Story','',NULL,'',NULL,NULL,'PAGE',NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(91012,91001,'WECHAT','MENU','鲜肉理念','Fresh Idea','',NULL,'',NULL,NULL,'PAGE',NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(92001,0,'MINIAPP','MENU','首页','Home','/pages/index/index',NULL,'ep:home-filled',NULL,NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(92002,0,'MINIAPP','MENU','分类','Category','/pages/category/index',NULL,'ep:grid',NULL,NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(92003,0,'MINIAPP','MENU','鲜肉预订','Reserve','/pages/reserve/index',NULL,'ep:timer',NULL,NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(92004,0,'MINIAPP','MENU','购物车','Cart','/pages/cart/index',NULL,'ep:shopping-cart',NULL,NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(92005,0,'MINIAPP','MENU','我的','Mine','/pages/mine/index',NULL,'ep:user',NULL,NULL,NULL,NULL,NULL,5,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(93001,0,'H5','LINK','首页','Home','/',NULL,'',NULL,NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(93002,0,'H5','LINK','火锅套餐','Combo','/combo',NULL,'',NULL,NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(93003,0,'H5','LINK','我的','Mine','/mine',NULL,'',NULL,NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(100201,1002,'ADMIN','BUTTON','文章新增',NULL,NULL,NULL,NULL,'cms:article:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(100202,1002,'ADMIN','BUTTON','文章编辑',NULL,NULL,NULL,NULL,'cms:article:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(100203,1002,'ADMIN','BUTTON','文章删除',NULL,NULL,NULL,NULL,'cms:article:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(100401,1004,'ADMIN','BUTTON','留言处理',NULL,NULL,NULL,NULL,'cms:message:handle',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(110101,1101,'ADMIN','BUTTON','菜单新增',NULL,NULL,NULL,NULL,'wechat:menu:add',NULL,NULL,NULL,NULL,1,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(110102,1101,'ADMIN','BUTTON','菜单编辑',NULL,NULL,NULL,NULL,'wechat:menu:edit',NULL,NULL,NULL,NULL,2,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(110103,1101,'ADMIN','BUTTON','菜单删除',NULL,NULL,NULL,NULL,'wechat:menu:del',NULL,NULL,NULL,NULL,3,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(110104,1101,'ADMIN','BUTTON','预览到微信',NULL,NULL,NULL,NULL,'wechat:menu:preview',NULL,NULL,NULL,NULL,4,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(110105,1101,'ADMIN','BUTTON','发布菜单',NULL,NULL,NULL,NULL,'wechat:menu:publish',NULL,NULL,NULL,NULL,5,1,1,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(64) NOT NULL COMMENT '角色编码',
  `name` varchar(64) NOT NULL COMMENT '角色名称',
  `platform` varchar(20) NOT NULL DEFAULT 'ADMIN' COMMENT 'ADMIN/CUSTOMER/SUPPLIER/CHANNEL/STAFF',
  `data_scope` varchar(20) NOT NULL DEFAULT 'SELF' COMMENT 'ALL/STORE/SELF',
  `sort` int NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'SUPER_ADMIN','超级管理员','ADMIN','ALL',1,1,'拥有全部功能维护权限','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'STORE_MANAGER','店长','ADMIN','STORE',2,1,'门店数据','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'FINANCE','财务','ADMIN','ALL',3,1,'结算/对账','2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,'CLERK','店员','STAFF','STORE',4,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,'CUTTER','分割师傅','STAFF','STORE',5,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(6,'SERVICE','客服','ADMIN','ALL',6,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(7,'SUPPLIER','供应商管理员','SUPPLIER','SELF',7,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(8,'CHANNEL','渠道商管理员','CHANNEL','SELF',8,1,NULL,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL,
  `menu_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_menu` (`role_id`,`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=817 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色菜单关联';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (375,1,1),(376,1,10),(377,1,20),(378,1,30),(379,1,40),(380,1,50),(381,1,60),(382,1,70),(383,1,80),(384,1,90),(385,1,100),(405,1,101),(406,1,102),(407,1,103),(408,1,104),(409,1,105),(410,1,106),(411,1,107),(412,1,108),(386,1,110),(387,1,120),(416,1,301),(417,1,302),(418,1,303),(419,1,401),(420,1,402),(421,1,403),(422,1,501),(423,1,502),(424,1,601),(425,1,602),(426,1,603),(427,1,604),(428,1,605),(429,1,701),(430,1,702),(431,1,703),(432,1,704),(433,1,705),(434,1,706),(435,1,707),(436,1,708),(437,1,709),(438,1,801),(439,1,802),(440,1,803),(441,1,804),(442,1,805),(443,1,901),(444,1,902),(445,1,903),(446,1,904),(447,1,905),(448,1,1001),(449,1,1002),(450,1,1003),(451,1,1004),(475,1,1101),(476,1,1102),(477,1,1103),(413,1,2001),(414,1,2002),(415,1,2003),(452,1,10101),(453,1,10102),(454,1,10103),(455,1,10104),(456,1,10201),(457,1,10202),(458,1,10203),(459,1,10204),(460,1,10301),(461,1,10302),(462,1,10303),(463,1,10304),(464,1,10401),(465,1,10402),(466,1,10403),(467,1,10501),(468,1,10502),(469,1,10503),(470,1,10601),(471,1,10602),(472,1,10603),(473,1,10801),(474,1,10802),(478,1,30101),(479,1,30102),(480,1,30103),(481,1,30201),(482,1,30202),(483,1,30203),(484,1,30204),(485,1,30205),(486,1,30301),(487,1,30302),(488,1,30303),(489,1,40101),(490,1,40102),(491,1,40201),(492,1,40301),(493,1,50101),(494,1,50102),(495,1,50103),(496,1,50104),(497,1,50201),(498,1,50202),(499,1,60101),(500,1,60102),(501,1,60103),(502,1,60201),(503,1,60202),(504,1,60203),(505,1,60301),(506,1,60302),(507,1,60303),(508,1,70101),(509,1,70102),(510,1,70103),(511,1,70201),(512,1,70202),(513,1,70301),(514,1,70401),(515,1,70501),(516,1,70502),(517,1,70503),(518,1,70701),(519,1,70702),(520,1,70801),(521,1,80101),(522,1,80102),(523,1,80103),(524,1,80201),(525,1,80202),(526,1,80203),(527,1,80301),(528,1,80401),(529,1,80402),(388,1,90001),(389,1,90002),(390,1,90003),(391,1,90004),(392,1,90005),(393,1,90006),(530,1,90101),(531,1,90102),(532,1,90103),(533,1,90201),(534,1,90301),(535,1,90401),(394,1,91001),(395,1,91002),(396,1,91003),(545,1,91011),(546,1,91012),(397,1,92001),(398,1,92002),(399,1,92003),(400,1,92004),(401,1,92005),(402,1,93001),(403,1,93002),(404,1,93003),(536,1,100201),(537,1,100202),(538,1,100203),(539,1,100401),(540,1,110101),(541,1,110102),(542,1,110103),(543,1,110104),(544,1,110105),(754,2,1),(755,2,20),(756,2,30),(757,2,40),(758,2,50),(759,2,90),(760,2,120),(761,2,301),(762,2,302),(763,2,303),(764,2,401),(765,2,402),(766,2,403),(767,2,501),(768,2,502),(769,2,901),(770,2,902),(771,2,903),(772,2,904),(773,2,905),(774,2,2001),(775,2,2002),(776,2,2003),(777,2,30101),(778,2,30102),(779,2,30103),(780,2,30201),(781,2,30202),(782,2,30203),(783,2,30204),(784,2,30205),(785,2,40101),(786,2,40102),(787,2,40201),(788,2,40301),(789,2,50101),(790,2,50102),(791,2,50103),(792,2,50104),(793,2,90201),(794,2,90301),(795,2,90401),(697,3,1),(698,3,70),(699,3,80),(700,3,120),(701,3,707),(702,3,804),(693,3,70701),(694,3,70702),(695,3,80401),(696,3,80402),(708,4,1),(709,4,90),(710,4,902),(711,4,904),(712,4,905),(713,4,90201),(714,4,90401),(715,5,1),(716,5,903),(717,5,90301),(728,6,1),(729,6,50),(730,6,60),(731,6,120),(732,6,501),(733,6,502),(734,6,601),(735,6,1004),(718,6,50101),(719,6,50102),(720,6,50103),(721,6,50104),(722,6,50201),(723,6,50202),(724,6,60101),(725,6,60102),(726,6,60103),(727,6,100401);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(64) NOT NULL COMMENT '登录账号',
  `password` varchar(100) NOT NULL COMMENT 'BCrypt 密码',
  `nickname` varchar(64) DEFAULT NULL COMMENT '昵称',
  `real_name` varchar(64) DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `user_type` varchar(20) NOT NULL DEFAULT 'ADMIN' COMMENT 'ADMIN/STORE_MANAGER/FINANCE/CLERK/CUTTER/CUSTOMER/SERVICE/SUPPLIER/CHANNEL',
  `store_id` bigint DEFAULT NULL COMMENT '所属门店(店员/店长)',
  `is_super` tinyint NOT NULL DEFAULT '0' COMMENT '是否超级管理员 1=是(拥有全量维护权限)',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态 1=启用 0=禁用',
  `last_login_time` datetime DEFAULT NULL COMMENT '最近登录时间',
  `last_login_ip` varchar(64) DEFAULT NULL COMMENT '最近登录IP',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='后台/端用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'admin','$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','超级管理员','超级管理员','13800000000',NULL,NULL,'ADMIN',NULL,1,1,'2026-10-16 21:31:53','127.0.0.1','超级管理员(全量维护)','2026-10-16 18:59:58','2026-10-16 21:31:53',0),(2,'store01','$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','西城店店长','王店长','13800000001',NULL,NULL,'STORE_MANAGER',NULL,0,1,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 20:50:26',0),(3,'finance01','$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','财务小李','李财务','13800000002',NULL,NULL,'FINANCE',NULL,0,1,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 20:50:26',0),(4,'clerk01','$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','店员小张','张店员','13800000003',NULL,NULL,'CLERK',NULL,0,1,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 20:50:26',0),(5,'cutter01','$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','分割师傅','赵师傅','13800000004',NULL,NULL,'CUTTER',NULL,0,1,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 20:50:26',0),(6,'service01','$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','客服小刘','刘客服','13800000005',NULL,NULL,'SERVICE',NULL,0,1,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 20:50:26',0),(7,'supplier01','$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','供货商账号','某供应商','13800000006',NULL,NULL,'SUPPLIER',NULL,0,1,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 20:50:26',0),(8,'channel01','$2a$10$l5upxv28Yj6hn3TVIPf/7.a/MQhlIdxxDTdG64VUZXeVa8NVbW32e','渠道商账号','某渠道商','13800000007',NULL,NULL,'CHANNEL',NULL,0,1,NULL,NULL,NULL,'2026-10-16 18:59:58','2026-10-16 20:50:26',0);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`,`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户角色关联';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (17,1,1),(18,2,2),(19,3,3),(20,4,4),(21,5,5),(22,6,6),(23,7,7),(24,8,8);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wechat_menu_publish`
--

DROP TABLE IF EXISTS `wechat_menu_publish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wechat_menu_publish` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `menu_json` longtext COMMENT '发布快照(公众号菜单 JSON)',
  `publish_user` varchar(64) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'SUCCESS' COMMENT 'SUCCESS/FAILED',
  `message` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='公众号菜单发布记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wechat_menu_publish`
--

LOCK TABLES `wechat_menu_publish` WRITE;
/*!40000 ALTER TABLE `wechat_menu_publish` DISABLE KEYS */;
/*!40000 ALTER TABLE `wechat_menu_publish` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wechat_msg_log`
--

DROP TABLE IF EXISTS `wechat_msg_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wechat_msg_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `openid` varchar(64) DEFAULT NULL,
  `unionid` varchar(64) DEFAULT NULL,
  `biz_type` varchar(32) DEFAULT NULL,
  `template_id` varchar(128) DEFAULT NULL,
  `content` text,
  `status` tinyint NOT NULL DEFAULT '1',
  `error_msg` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='模板消息发送日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wechat_msg_log`
--

LOCK TABLES `wechat_msg_log` WRITE;
/*!40000 ALTER TABLE `wechat_msg_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `wechat_msg_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wechat_template`
--

DROP TABLE IF EXISTS `wechat_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wechat_template` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `biz_type` varchar(32) NOT NULL COMMENT 'ORDER_PAID/ORDER_PREPARING/ORDER_READY/ORDER_DELIVERING/ACTIVITY',
  `template_id` varchar(128) DEFAULT NULL COMMENT '微信模板ID',
  `title` varchar(128) DEFAULT NULL,
  `content_json` text COMMENT '模板字段映射',
  `status` tinyint NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_biz_type` (`biz_type`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='公众号模板消息配置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wechat_template`
--

LOCK TABLES `wechat_template` WRITE;
/*!40000 ALTER TABLE `wechat_template` DISABLE KEYS */;
INSERT INTO `wechat_template` VALUES (1,'ORDER_PAID','','订单支付成功通知',NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(2,'ORDER_PREPARING','','订单备货中通知',NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(3,'ORDER_READY','','订单可自提通知',NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(4,'ORDER_DELIVERING','','订单配送中通知',NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0),(5,'ACTIVITY','','活动通知',NULL,1,'2026-10-16 18:59:58','2026-10-16 18:59:58',0);
/*!40000 ALTER TABLE `wechat_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'zhushu'
--

--
-- Dumping routines for database 'zhushu'
--
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-16 21:42:01
