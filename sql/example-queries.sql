SELECT * FROM user ORDER BY n_followers;
SELECT u.name, COUNT(*)
FROM user u
JOIN post p ON p.user=u.id
;

SELECT u.name, COUNT(*)
FROM post p
LEFT JOIN user u ON u.id=p.user
GROUP BY p.user
;


-- Posts by 'visibility'
SELECT SUM(u.n_followers) AS `c`, a.name, CONCAT("https://twitter.com/i/status/", p.id)
FROM user u
JOIN post2like p2l ON p2l.user=u.id
JOIN post p ON p.id=p2l.post
JOIN user a ON a.id=p.user
GROUP BY p.id
ORDER BY c DESC
LIMIT 50
;
-- Find who liked a post, ordered by followers
SELECT u.n_followers, u.name
FROM user u
JOIN post2like p2l ON p2l.user=u.id
WHERE p2l.post=554102379243905024
ORDER BY u.n_followers DESC
LIMIT 10
;


-- Verified likes
SELECT u.name, a.name, COUNT(*), CONCAT("https://twitter.com/", a.name, "/status/", p.id) AS `eg`
FROM post2like p2l
JOIN post p ON p.id=p2l.post
JOIN user a ON a.id=p.user
JOIN user u ON u.id=p2l.user
WHERE u.verified
GROUP BY u.id, a.id
;


-- Most liked post per user
SELECT MAX(A.n) AS `max`, a.name, CONCAT("https://twitter.com/", a.name, "/status/", p.id)
FROM (
	SELECT post, COUNT(*) AS `n`
	FROM post2like
	GROUP BY post
) A
JOIN post p ON p.id=A.post
JOIN user a ON a.id=p.user
GROUP BY a.id
ORDER BY max
;
