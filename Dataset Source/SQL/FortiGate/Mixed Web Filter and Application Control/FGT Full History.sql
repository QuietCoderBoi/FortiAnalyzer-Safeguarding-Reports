SELECT
	cal_time,
	user_src,
	(CASE
		WHEN event_source_raw ~ 'Search.Phrase' THEN event_source_raw
		ELSE SUBSTRING(event_source_raw, '(?:[-a-zA-Z0-9@:%_\+~.#=]{2,100}\.)?([-a-zA-Z0-9@:%_\+~#=]*\.[a-z]{2,6})(?:[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)')
	END) AS event_source,
	search_query,
	web_catdesc,
	KCSIEC
FROM
	(
		###(
			SELECT
				$calendar_time AS cal_time,
				COALESCE(
					nullifna(SUBSTRING(lower(`user`), '^[A-Za-z0-9\\_\.-]{0,}')),
					nullifna(SUBSTRING(lower(`unauthuser`), '^[A-Za-z0-9\\_\.-]{0,}'))
					-- ipstr(srcip)
				) AS user_src,
				`hostname` AS event_source_raw,
				`keyword` AS search_query,
				`catdesc` AS web_catdesc,
				(CASE 
					WHEN `catdesc` ~ 'Abortion|Alcohol|Alternative Beliefs|Discrimination|Domain Parking|Drug Abuse|Dynamic Content|Explicit Violence|Extremist Groups|Illegal and Unethical|Lingerie and Swimsuit|Malicious Websites|Marijuana|Nudity and Risque|Other Adult Materials|Peer-to-peer File Sharing|Spam URLs|Sports Hunting and War Games|Terrorism|Tobacco|URL Shortening|Weapons (Sales)' THEN 'Content'
					WHEN `catdesc` ~ 'Child Sexual Abuse|Dating|Games|Instant Messaging|Internet Telephony|Newsgroups and Message Boards|Online Meeting|Social Networking|Web Chat' THEN 'Contact'
					WHEN `catdesc` ~ 'Advertising|Brokerage and Trading|Crypto Mining|Gambling|Phishing|Potentially Unwanted Program' THEN 'Commerce'
					ELSE NULL
				END) AS KCSIEC
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
				`catdesc`
			ORDER BY
				cal_time
		)###
		UNION ALL
		###(
			SELECT
				$calendar_time AS cal_time,
				COALESCE(
					nullifna(SUBSTRING(lower(`user`), '^[A-Za-z0-9\\_\.-]{0,}')),
					nullifna(SUBSTRING(lower(`unauthuser`), '^[A-Za-z0-9\\_\.-]{0,}'))
					-- ipstr(srcip)
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
GROUP BY
	user_src,
	event_source,
	web_catdesc,
	KCSIEC,
	search_query,
	cal_time
ORDER BY
	cal_time