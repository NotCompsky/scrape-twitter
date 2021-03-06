CREATE DATABASE twitter;
USE twitter;

CREATE TABLE user (
	id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	name VARBINARY(32) NOT NULL UNIQUE  KEY,
	full_name VARCHAR(64),
	t BIGINT UNSIGNED NOT NULL,
	n_followers BIGINT UNSIGNED NOT NULL,
	n_friends BIGINT UNSIGNED NOT NULL,
	private BOOLEAN DEFAULT FALSE,
	verified BOOLEAN DEFAULT FALSE,
	nsfw BOOLEAN DEFAULT FALSE
);
CREATE TABLE post (
	id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	user BIGINT UNSIGNED NOT NULL,
	parent BIGINT UNSIGNED,
	t BIGINT UNSIGNED NOT NULL,
	text VARCHAR(2200),
	reached_last_cmnt BOOLEAN NOT NULL DEFAULT FALSE,
	reached_last_like BOOLEAN NOT NULL DEFAULT FALSE,
	FOREIGN KEY (parent) REFERENCES post (id)
);
CREATE TABLE post2like (
	post BIGINT UNSIGNED NOT NULL,
	user BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (post) REFERENCES post (id),
	FOREIGN KEY (user) REFERENCES user (id),
	UNIQUE KEY (post,user)
);

CREATE TABLE user2tag (
	user BIGINT UNSIGNED NOT NULL,
	tag BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (user) REFERENCES user (id),
	UNIQUE KEY (user,tag)
);
