SELECT
	user_src,
	`threat`,
	`remotename`,
	SUBSTRING(`remotename`, '(?:[-a-zA-Z0-9@:%_\+~.#=]{2,100}\.)?([-a-zA-Z0-9@:%_\+~#=]*\.[a-z]{2,6})(?:[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)') AS SLD,
	KCSIEC,
	cal_time,
	string_agg(DISTINCT cal_time, chr(10)) AS cal_time__agg_,
	count(*) AS requests
FROM
	###(
		SELECT
			$calendar_time AS cal_time,
			`threat`,
			`remotename`,
			-- TODO: Cases need adjusting to reflect FCT web category log format.
			(CASE
				WHEN `thread` ~ 'Advertising|Brokerage and Trading|Crypto Mining|Gambling|Phishing|Potentially Unwanted Program' THEN 'Commerce'
				ELSE NULL
			END) AS KCSIEC,
			SUBSTRING(lower(`user`), '^[A-Za-z0-9\\_\.-]{0,}') AS user_src
		FROM
			$log
		WHERE
			$filter
		GROUP BY
			cal_time,
			`threat`,
			`remotename`,
			KCSIEC,
			user_src
		/*SkipSTART*/
		ORDER BY
			cal_time
		/*SkipEND*/
	)### t
WHERE
	KCSIEC IS NOT NULL
GROUP BY
	user_src
	`threat`,
	`remotename`,
	SLD,
	KCSIEC,
	cal_time
ORDER BY
	cal_time__agg_ ASC,
	cal_time ASC
