SELECT
	cal_time,
	user_src,
	event_source_raw AS event_source,
	search_query,
	web_catdesc,
	SafeCat
FROM
	(
		###(
			SELECT
				$calendar_time AS cal_time,
				COALESCE(
					nullifna(SUBSTRING(lower(`user`), '^[A-Za-z0-9\\_\.-]{0,}')),
					ipstr(srcip)
				) AS user_src,
				`hostname` AS event_source_raw,
				NULL AS search_query,
				`catdesc` AS web_catdesc,
				(CASE
					WHEN `cat` IN (1,4,5,6,7,26,57) THEN 'General Concern'
					WHEN `cat` IN (83) THEN 'Sexual Abuse'
					WHEN `cat` IN (12,96) THEN 'Prevent Duty'
					WHEN `cat` IN (16) THEN 'Weapons'
					WHEN `cat` IN (8,11,14,64,65,67) THEN 'Informational'
					ELSE NULL
				END) AS SafeCat
			FROM
				$log-webfilter
			WHERE
				$filter
			GROUP BY
				cal_time,
				`user`,
				`unauthuser`,
				srcip,
				`hostname`,
				`keyword`,
				`catdesc`,
          		`cat`
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
				`app`,
				`filename`,
				NULL AS dummy_1,
				NULL AS dummy_2
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
				`app`,
				`filename`
			ORDER BY
				cal_time
		)###
	) t_combined
WHERE
	user_src IS NOT NULL
AND
	(web_catdesc IS NOT NULL OR search_query IS NOT NULL)
GROUP BY
	user_src,
	event_source,
	web_catdesc,
	SafeCat,
	search_query,
	cal_time
ORDER BY
	cal_time