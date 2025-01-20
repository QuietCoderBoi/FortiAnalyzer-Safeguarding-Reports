SELECT
	user_src,
	`catdesc`,
	`hostname`,
	SafeCat,
	`keyword`,
	cal_time,
	count(*) AS requests
FROM
	###(
		SELECT
			$calendar_time as cal_time,
			`catdesc`,
			`hostname`,
			`keyword`,
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
			`keyword`,
			user_src
		/*SkipSTART*/
		ORDER BY
			cal_time
		/*SkipEND*/
	)### t
WHERE
	user_src IS NOT NULL AND (
		`catdesc` IS NOT NULL OR `keyword` IS NOT NULL
	)
GROUP BY
	user_src,
	`catdesc`,
	`hostname`,
	SafeCat,
	`keyword`,
	cal_time
ORDER BY
	cal_time