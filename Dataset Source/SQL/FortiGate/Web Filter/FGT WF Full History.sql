SELECT
	user_src,
	`catdesc`,
	`hostname`,
	SUBSTRING(`hostname`, '(?:[-a-zA-Z0-9@:%_\+~.#=]{2,100}\.)?([-a-zA-Z0-9@:%_\+~#=]*\.[a-z]{2,6})(?:[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)') AS SLD,
	KCSIEC,
	`keyword`,
	cal_time,
	string_agg(DISTINCT cal_time, chr(10)) AS cal_time__agg_,
	count(*) AS requests
FROM
	###(
		SELECT
	  		$calendar_time AS cal_time,
			`catdesc`,
			`hostname`,
			(CASE 
				WHEN `catdesc` ~ 'Abortion|Alcohol|Alternative Beliefs|Discrimination|Domain Parking|Drug Abuse|Dynamic Content|Explicit Violence|Extremist Groups|Illegal and Unethical|Lingerie and Swimsuit|Malicious Websites|Marijuana|Nudity and Risque|Other Adult Materials|Peer-to-peer File Sharing|Spam URLs|Sports Hunting and War Games|Terrorism|Tobacco|URL Shortening|Weapons (Sales)' THEN 'Content'
				WHEN `catdesc` ~ 'Child Sexual Abuse|Dating|Games|Instant Messaging|Internet Telephony|Newsgroups and Message Boards|Online Meeting|Social Networking|Web Chat' THEN 'Contact'
				WHEN `catdesc` ~ 'Advertising|Brokerage and Trading|Crypto Mining|Gambling|Phishing|Potentially Unwanted Program' THEN 'Commerce'
				ELSE NULL
			END) AS KCSIEC,
      		`keyword`,
			COALESCE(
				nullifna(SUBSTRING(lower(`user`), '^[A-Za-z0-9\\_\.-]{0,}')),
				ipstr(srcip)
			) AS user_src
		FROM
			$log
		WHERE
			$filter
	  	GROUP BY
	  		cal_time,
	  		`catdesc`,
	  		`hostname`,
			KCSIEC,
      		`keyword`,
	  		user_src
	  	/*SkipSTART*/
	  	ORDER BY
	  		cal_time
	  	/*SkipEND*/
	)### t
WHERE
	user_src IS NOT NULL
AND (
	`catdesc` IS NOT NULL OR `keyword` IS NOT NULL
)
GROUP BY
	user_src,
	`catdesc`,
	`hostname`,
    SLD,
	KCSIEC,
	`keyword`,
	cal_time
ORDER BY
	cal_time__agg_ ASC,
	cal_time ASC