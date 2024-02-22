SELECT
	user_src,
	`threat`,
	`remotename`,
	SUBSTRING(`remotename`, '(?:[-a-zA-Z0-9@:%_\+~.#=]{2,100}\.)?([-a-zA-Z0-9@:%_\+~#=]*\.[a-z]{2,6})(?:[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)') AS SLD,
	KCSIEC,
	TRANSLATE(raw_queries, '+', ' ') AS queries,
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
				WHEN `threat` ~ 'Abortion|Alcohol|Alternative Beliefs|Discrimination|Domain Parking|Drug Abuse|Dynamic Content|Explicit Violence|Extremist Groups|Illegal and Unethical|Lingerie and Swimsuit|Malicious Websites|Marijuana|Nudity and Risque|Other Adult Materials|Peer-to-peer File Sharing|Spam URLs|Sports Hunting and War Games|Terrorism|Tobacco|URL Shortening|Weapons (Sales)' THEN 'Content'
				WHEN `threat` ~ 'Child Sexual Abuse|Dating|Games|Instant Messaging|Internet Telephony|Newsgroups and Message Boards|Online Meeting|Social Networking|Web Chat' THEN 'Contact'
				WHEN `thread` ~ 'Advertising|Brokerage and Trading|Crypto Mining|Gambling|Phishing|Potentially Unwanted Program' THEN 'Commerce'
				ELSE NULL
			END) AS KCSIEC,
			(CASE
				WHEN `remotename` ~ '.*\.bing\..*' THEN SUBSTRING(`url`, '(?<=\/images|\/videos)?(?<=\/search|\/async|\/asyncv2)?(?<=q=).*?(?=&)')
				WHEN `remotename` ~ '.*\.google\..*' THEN SUBSTRING(`url`, '(?<=\/custom|search|images|videosearch|webhp\?)?(?<=q=).*?(?=&)')
				WHEN `remotename` ~ '.*\.yahoo\..*' THEN SUBSTRING(`url`, '(?<=\/search\/video|\/images){0,1}(?=\?|;)?(?<=p=).*?(?=&)')
				WHEN `remotename` ~ 'yandex\..*' THEN SUBSTRING(`url`, '(?<=\/yand|images\/|video\/)?(?<=search)?(?<=text=).*?(?=&)')
				WHEN `remotename` ~ '^duckduckgo\\..*' THEN SUBSTRING(`url`, '(?<=\/\?)?(?<=q=).*?(?=&)')
				ELSE NULL
			END) AS raw_queries,
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
			raw_queries,
			user_src
		/*SkipSTART*/
		ORDER BY
			cal_time
		/*SkipEND*/
	)### t
WHERE
	`threat` IS NOT NULL OR queries IS NOT NULL
GROUP BY
	user_src,
	`threat`,
	`remotename`,
	SLD,
	KCSIEC,
	queries,
	cal_time
ORDER BY
	cal_time__agg_,
	cal_time