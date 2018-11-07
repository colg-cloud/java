/*
SQLyog Ultimate v12.4.1 (64 bit)
MySQL - 5.7.19 : Database - girls
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`girls` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `girls`;

/*Table structure for table `admin` */

DROP TABLE IF EXISTS `admin`;

CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户编号',
  `username` varchar(10) NOT NULL COMMENT '用户名称',
  `password` varchar(10) NOT NULL COMMENT '用户密码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='用户表';

/*Data for the table `admin` */

insert  into `admin`(`id`,`username`,`password`) values 
(1,'john','8888'),
(2,'lyt','6666');

/*Table structure for table `beauty` */

DROP TABLE IF EXISTS `beauty`;

CREATE TABLE `beauty` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '女生编号',
  `beautyName` varchar(50) NOT NULL COMMENT '姓名',
  `sex` char(1) DEFAULT '女' COMMENT '性别',
  `borndate` datetime DEFAULT '1987-01-01 00:00:00' COMMENT '出生日期',
  `phone` varchar(11) NOT NULL COMMENT '手机号码',
  `photo` blob COMMENT '照片',
  `boyfriend_id` int(11) DEFAULT NULL COMMENT '男朋友编号',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='女生表';

/*Data for the table `beauty` */

insert  into `beauty`(`id`,`beautyName`,`sex`,`borndate`,`phone`,`photo`,`boyfriend_id`) values 
(1,'柳岩','女','1988-02-03 00:00:00','18209876577',NULL,8),
(2,'苍老师','女','1987-12-30 00:00:00','18219876577',NULL,9),
(3,'Angelababy','女','1989-02-03 00:00:00','18209876567',NULL,3),
(4,'热巴','女','1993-02-03 00:00:00','18209876579',NULL,2),
(5,'周冬雨','女','1992-02-03 00:00:00','18209179577',NULL,9),
(6,'周芷若','女','1988-02-03 00:00:00','18209876577',NULL,1),
(7,'岳灵珊','女','1987-12-30 00:00:00','18219876577',NULL,9),
(8,'小昭','女','1989-02-03 00:00:00','18209876567',NULL,1),
(9,'双儿','女','1993-02-03 00:00:00','18209876579',NULL,9),
(10,'王语嫣','女','1992-02-03 00:00:00','18209179577',NULL,4),
(11,'夏雪','女','1993-02-03 00:00:00','18209876579',NULL,9),
(12,'赵敏','女','1992-02-03 00:00:00','18209179577',NULL,1);

/*Table structure for table `boys` */

DROP TABLE IF EXISTS `boys`;

CREATE TABLE `boys` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '男生编号',
  `boyName` varchar(20) DEFAULT NULL COMMENT '姓名',
  `userCP` int(11) DEFAULT NULL COMMENT 'xx',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='男生表';

/*Data for the table `boys` */

insert  into `boys`(`id`,`boyName`,`userCP`) values 
(1,'张无忌',100),
(2,'鹿晗',800),
(3,'黄晓明',50),
(4,'段誉',300);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
