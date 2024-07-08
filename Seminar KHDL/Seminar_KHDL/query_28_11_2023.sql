-- lấy tất cả các thể loại phim có thể có trong bộ data IMDB
SELECT DISTINCT genres
FROM title_basics;

SELECT DISTINCT category
FROM title_principals;
-- lấy thể loại phim của Five night ad freddy
select genres from title_basics where tconst = 'tt4589218'
-- nếu nó có nhiều thể loại thì xử lý bằng python để tách riêng ra từng thể 
-- loại để dễ lọc ở bước dưới hơn
-- tiếp theo lấy info nconst cua nhung nguoi gop mat trong bo phim "Five Nights at Freddy's"
-- ở đây sẽ lấy những người có vai trò tác động lớn đến phim
SELECT *
FROM title_principals
WHERE category IN ('director', 'writer', 'actor', 'actress', 'editor', 'composer')
AND (tconst = 'tt4589218')

-- lấy thông tin những bộ phim mà những người trên góp mặt từ trước đến nay


SELECT tconst, nconst
FROM title_principals
WHERE nconst IN
(
    SELECT nconst
	FROM title_principals
	WHERE category IN ('director', 'writer', 'actor', 'actress', 'editor', 'composer')
	AND (tconst = 'tt4589218')
)
ORDER BY nconst;

--lấy thông tin về những bộ phim có dạng là movie và do những người trên tham gia
SELECT *
FROM title_basics as basics
WHERE 
	(basics.titletype = 'movie')
	and
	(tconst IN (
    SELECT principal.tconst
    FROM title_principals as principal
    WHERE nconst IN (
		SELECT nconst
		FROM title_principals
		WHERE category IN ('director', 'writer', 'actor', 'actress', 'editor', 'composer')
		AND (tconst = 'tt4589218')
	)))
	
-> horror -> điểm
-- Truy vấn những bộ phim có cùng thể loại của bộ phim (tối đa 2, 3 thể loại)
-- (ở đây thì bộ Five night at freddy là thể loại horror nên tìm những 
-- cái liên quan tới horror hoặc thriller thôi)
SELECT *
FROM title_basics as basics
WHERE
	(basics.titletype = 'movie')
	and
		(basics.genres LIKE '%Horror%'
	 	or basics.genres LIKE '%Thriller%')
	and
	(tconst IN (
    SELECT principal.tconst
    FROM title_principals as principal
    WHERE nconst IN (
		SELECT nconst
		FROM title_principals
		WHERE category IN ('director', 'writer', 'actor', 'actress', 'editor', 'composer')
		AND (tconst = 'tt4589218')
	)))
-- tới đây thì join 2 bảng lại, 1 bảng là title_rating với 1 bảng là cái mình vừa truy vấn ra
SELECT *
FROM title_ratings
JOIN (
    -- Kết quả của truy vấn trước
    SELECT *
FROM title_basics as basics
WHERE 
	(basics.titletype = 'movie')
	and
		(basics.genres LIKE '%Horror%'
	 	or basics.genres LIKE '%Thriller%')
	and
	(tconst IN (
    SELECT principal.tconst
    FROM title_principals as principal
    WHERE nconst IN (
		SELECT nconst
		FROM title_principals
		WHERE category IN ('director', 'writer', 'actor', 'actress', 'editor', 'composer')
		AND (tconst = 'tt4589218')
	)))
) AS subquery_result
ON title_ratings.tconst = subquery_result.tconst;
-- có 32 dòng nhưng sau khi join còn có 21, t nghĩ là do có trường hợp
-- có những phim ko có rating nên bị tụt xuống còn 21 bộ
-- ví dụ như bộ tt27116380 ko có data trong bảng ratings
select * from title_ratings where tconst = 'tt27116380'