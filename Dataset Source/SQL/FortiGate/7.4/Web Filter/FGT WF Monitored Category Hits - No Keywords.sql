SELECT
	user_src,
	`catdesc`,
	`hostname`,
	SafeCat,
	cal_time,
	count(*) AS requests
FROM
	###(
		SELECT
			$calendar_time as cal_time,
			`catdesc`,
			`hostname`,
			(CASE
				WHEN `cat` IN (1,4,5,6,7,26,57) THEN 'General Concern'
				WHEN `cat` IN (83) THEN 'Sexual Abuse'
				WHEN `cat` IN (12,96) THEN 'Prevent Duty'
				WHEN `cat` IN (16) THEN 'Weapons'
				WHEN `cat` IN (8,11,14,64,65,67) THEN 'Informational'
				ELSE NULL
			END) AS SafeCat,
			COALESCE(
				nullifna(SUBSTRING(lower(`user`), '^[A-Za-z0-9\\_\.-]{0,}')),
				ipstr(srcip)
			) AS user_src
		FROM
			$log-webfilter
		WHERE
			$filter
		GROUP BY
			cal_time,
			`catdesc`,
			`hostname`,
			SafeCat,
			user_src
		/*SkipSTART*/
		ORDER BY
			cal_time
		/*SkipEND*/
	)### t
WHERE
	user_src IS NOT NULL AND SafeCat IS NOT NULL
GROUP BY
	user_src,
	`catdesc`,
	`hostname`,
	SafeCat,
	cal_time
ORDER BY
	user_src,
	(CASE
		WHEN SafeCat = 'Sexual Abuse' THEN 1
		WHEN SafeCat = 'Prevent Duty' THEN 2
		WHEN SafeCat = 'Weapons' THEN 3
		WHEN SafeCat = 'General Concern' THEN 4
		WHEN SafeCat = 'Informational' THEN 5
	END),
    cal_time