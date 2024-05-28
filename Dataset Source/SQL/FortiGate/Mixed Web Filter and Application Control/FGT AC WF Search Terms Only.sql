SELECT
	cal_time,
	user_src,
	search_query
FROM
	(
		###(
			SELECT
				$calendar_time AS cal_time,
				COALESCE(
					nullifna(SUBSTRING(lower(`user`), '^[A-Za-z0-9\\_\.-]{0,}')),
					nullifna(SUBSTRING(lower(`unauthuser`), '^[A-Za-z0-9\\_\.-]{0,}')),
					ipstr(srcip)
				) AS user_src,
				`keyword` AS search_query
			FROM
				$log-webfilter
			WHERE
				$filter
			GROUP BY
				cal_time,
				`user`,
				`unauthuser`,
				srcip,
				`keyword`
			ORDER BY
				cal_time
		)###
		UNION ALL
		###(
			SELECT
				$calendar_time AS cal_time,
				COALESCE(
					nullifna(SUBSTRING(lower(`user`), '^[A-Za-z0-9\\_\.-]{0,}')),
					ipstr(srcip)
				) AS user_src,
				`filename`
			FROM
				$log-app-ctrl
			WHERE
				$filter
			AND (
				`app` ~ 'Search.Phrase' AND `filename` IS NOT NULL
			)
			GROUP BY
				cal_time,
				`user`,
				`unauthuser`,
				srcip,
				`filename`
			ORDER BY
				cal_time
		)###
	) t_combined
WHERE
	user_src IS NOT NULL AND search_query IS NOT NULL
GROUP BY
	user_src,
	search_query,
	cal_time
ORDER BY
	cal_time