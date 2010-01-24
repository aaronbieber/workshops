CREATE TABLE `administrators` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(64) NOT NULL default '',
  `pass` varchar(40) NOT NULL default '',
  `salt` varchar(10) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `modified_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `pages` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(128) NOT NULL default '',
  `name` varchar(128) NOT NULL default '',
  `text` text,
  `created_at` datetime NOT NULL,
  `modified_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `registrants` (
  `id` int(11) NOT NULL auto_increment,
  `student_id` int(11) default NULL,
  `workshop_id` int(11) default NULL,
  `payment_submitted` date default NULL,
  `payment_received` date default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `students` (
  `id` int(11) NOT NULL auto_increment,
  `first_name` varchar(64) NOT NULL default '',
  `last_name` varchar(64) NOT NULL default '',
  `email` varchar(128) NOT NULL default '',
  `address1` varchar(128) NOT NULL default '',
  `address2` varchar(128) default NULL,
  `city` varchar(128) NOT NULL default '',
  `state` varchar(2) NOT NULL default '',
  `zip` varchar(9) NOT NULL default '',
  `phone` varchar(10) default NULL,
  `ext` varchar(10) default NULL,
  `created_at` datetime NOT NULL,
  `modified_at` datetime default NULL,
  `pass` varchar(40) NOT NULL,
  `salt` varchar(10) default NULL,
  `new_password` varchar(32) default NULL,
  `new_password_date` date default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

CREATE TABLE `workshops` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `short_name` varchar(128) NOT NULL default '',
  `description` text NOT NULL,
  `cutoff_date` date NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `max_students` int(11) default NULL,
  `cost` float default NULL,
  `created_at` datetime NOT NULL,
  `modified_at` datetime default NULL,
  `active` tinyint(1) default '0',
  `thumbnail` varchar(255) default NULL,
  `short_desc` text,
  `full` tinyint(1) default '0',
  `ancestor_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('14');

INSERT INTO schema_migrations (version) VALUES ('15');

INSERT INTO schema_migrations (version) VALUES ('16');

INSERT INTO schema_migrations (version) VALUES ('17');

INSERT INTO schema_migrations (version) VALUES ('18');

INSERT INTO schema_migrations (version) VALUES ('19');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');