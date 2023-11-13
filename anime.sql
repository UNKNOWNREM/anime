-- Adminer 4.8.1 MySQL 5.5.5-10.5.12-MariaDB dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `anilist`;
CREATE TABLE `anilist` (
  `id` int(10) unsigned NOT NULL,
  `json` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (json_valid(`json`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `anilist_chinese`;
CREATE TABLE `anilist_chinese` (
  `id` int(10) unsigned NOT NULL,
  `json` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (json_valid(`json`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP VIEW IF EXISTS `anilist_view`;
CREATE TABLE `anilist_view` (`id` int(10) unsigned, `json` longtext);


DROP TABLE IF EXISTS `anime`;
CREATE TABLE `anime` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `anilist_id` mediumint(8) unsigned DEFAULT NULL,
  `season` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP VIEW IF EXISTS `anime_view`;
CREATE TABLE `anime_view` (`id` smallint(5) unsigned, `anilist_id` mediumint(8) unsigned, `season` varchar(256), `title` varchar(256), `updated` timestamp, `json` longtext);


DROP TABLE IF EXISTS `anilist_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anilist_view` AS select `anilist`.`id` AS `id`,json_merge_preserve(`anilist`.`json`,ifnull(`anilist_chinese`.`json`,json_object('title',json_object('chinese',NULL),'synonyms_chinese',json_array()))) AS `json` from (`anilist` left join `anilist_chinese` on(`anilist`.`id` = `anilist_chinese`.`id`));

DROP TABLE IF EXISTS `anime_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `anime_view` AS select `anime`.`id` AS `id`,`anime`.`anilist_id` AS `anilist_id`,`anime`.`season` AS `season`,`anime`.`title` AS `title`,`anime`.`updated` AS `updated`,`anilist_view`.`json` AS `json` from (`anime` left join `anilist_view` on(`anime`.`anilist_id` = `anilist_view`.`id`));

-- 2021-11-06 16:46:34
