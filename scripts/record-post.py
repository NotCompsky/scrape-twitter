#!/usr/bin/env python3


import json
import pymysql
from datetime import datetime as dt


def esc(s):
	return s.replace('\\\\','\\\\\\\\').replace('"','\\\\"')


def mysql_exec(s, user_id, username, tweet_id):
	try:
		cursor.execute(s)
	except pymysql.err.IntegrityError as e:
		print(f"{e.__class__.__name__}: {e}")
		print(user_id)
		print(username)
		print(tweet_id)


if __name__ == "__main__":
	import argparse
	
	parser = argparse.ArgumentParser()
	parser.add_argument("tweet_id")
	parser.add_argument("db_username")
	parser.add_argument("json_fp")
	args = parser.parse_args()
	
	db = pymysql.connect(db="twitter", user=args.db_username, host="localhost", unix_socket="/run/mysqld/mysqld.sock")
	cursor = db.cursor()

	d = json.load(open(args.json_fp))
	global_objs=d.get("globalObjects")
	if global_objs is None:
		err = d.get("errors")
		if err is not None and len(err) and err[0].get("code") in (131,):
			print(err[0].get("message"))
			exit()
		print(f"globalObjects not in d: {d}")
	for user in global_objs['users'].values():
		t = dt.strptime(user['created_at'], '%a %b %d %H:%M:%S +0000 %Y').timestamp()
		cursor.execute(f'''INSERT INTO user (id,name,full_name,n_followers,n_friends,t,verified,nsfw) VALUES (
			{user["id_str"]},
			"{user["screen_name"]}",
			"{esc(user["name"])}",
			{user["followers_count"]},
			{user["friends_count"]},
			{t},
			{user.get("verified",False)},
			{(user.get("profile_interstitial_type")=="sensitive_media")}
		)
		ON DUPLICATE KEY UPDATE n_followers=VALUES(n_followers), n_friends=VALUES(n_friends), verified=(verified OR VALUES(verified)), nsfw=VALUES(nsfw)
		''')
		db.commit()
		mysql_exec(f'INSERT INTO post2like (post,user) VALUES ({args.tweet_id},{user["id_str"]}) ON DUPLICATE KEY UPDATE post=post', user["id_str"], user["screen_name"], args.tweet_id)

	db.commit()
