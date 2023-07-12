
CREATE TABLE IF NOT EXISTS `kibra_motels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `roomid` varchar(11) NOT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `keydata` varchar(255) DEFAULT NULL,
  `bought` int(255) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO `kibra_motels` (`id`, `roomid`, `owner`, `keydata`, `bought`) VALUES
	(1, '1_1', NULL, NULL, 0),
	(3, '1_2', NULL, NULL, 0),
	(4, '1_4', NULL, NULL, 0),
	(5, '1_5', NULL, NULL, 0),
	(6, '1_6', NULL, NULL, 0),
	(7, '1_7', NULL, NULL, 0),
	(8, '1_8', NULL, NULL, 0),
	(9, '1_9', NULL, NULL, 0),
	(10, '1_10', NULL, NULL, 0),
	(11, '1_11', NULL, NULL, 0),
	(12, '1_12', NULL, NULL, 0),
	(13, '1_13', NULL, NULL, 0),
	(14, '1_14', NULL, NULL, 0),
	(15, '2_1', NULL, NULL, 0),
	(16, '2_2', NULL, NULL, 0),
	(17, '2_3', NULL, NULL, 0),
	(18, '2_4', NULL, NULL, 0),
	(19, '2_5', NULL, NULL, 0),
	(20, '2_6', NULL, NULL, 0),
	(21, '2_7', NULL, NULL, 0),
	(22, '2_9', NULL, NULL, 0),
	(23, '2_10', NULL, NULL, 0);
