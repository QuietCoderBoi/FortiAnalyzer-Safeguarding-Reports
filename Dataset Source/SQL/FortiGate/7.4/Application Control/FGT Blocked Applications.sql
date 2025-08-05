SELECT
	cal_time,
	user_src,
	`app`,
	string_agg(DISTINCT `app`, ' ') AS app__agg_,
	`appcat`,
	count(*) AS requests
FROM
	###(
		SELECT
			`app`,
			`appcat`,
			`action`,
			COALESCE(
				nullifna(SUBSTRING(lower(`user`), '^[A-Za-z0-9\\_\.-]{0,}')),
				nullifna(SUBSTRING(lower(`unauthuser`), '^[A-Za-z0-9\\_\.-]{0,}')),
				ipstr(srcip)
			) AS user_src,
			$calendar_time AS cal_time
		FROM
			$log
		WHERE
			$filter
		AND
			`action` = 'block'
		GROUP BY
			`app`,
			`appcat`,
			`action`,
			user_src,
			cal_time
		/*SkipSTART*/
		ORDER BY
			cal_time ASC,
			`appcat` DESC
		/*SkipEND*/
	)### t
WHERE
	user_src IS NOT NULL
GROUP BY
	cal_time,
	user_src,
	`app`,
	`appcat`
ORDER BY
	cal_time ASC,
	`appcat` DESC