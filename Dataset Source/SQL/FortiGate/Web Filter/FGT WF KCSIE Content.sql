SELECT
	user_src,
	SUBSTRING(`hostname`, '(?:[-a-zA-Z0-9@:%_\+~.#=]{2,100}\.)?([-a-zA-Z0-9@:%_\+~#=]*\.[a-z]{2,6})(?:[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)') AS SLD,
	KCSIE_CONTENT,
	cal_time,
	count(*) AS requests,
	`group`
FROM
	###(
		SELECT
	  		$calendar_time AS cal_time,
			`catdesc`,
			`hostname`,
			(CASE 
				WHEN `catdesc` ~ 'Abortion|Alcohol|Alternative Beliefs|Discrimination|Domain Parking|Drug Abuse|Dynamic Content|Explicit Violence|Extremist Groups|Illegal and Unethical|Lingerie and Swimsuit|Malicious Websites|Marijuana|Nudity and Risque|Other Adult Materials|Peer-to-peer File Sharing|Spam URLs|Sports Hunting and War Games|Terrorism|Tobacco|URL Shortening|Weapons (Sales)' THEN `catdesc`
				ELSE NULL
			END) AS KCSIE_CONTENT,
			COALESCE(
				nullifna(SUBSTRING(lower(`user`), '^[A-Za-z0-9\\_\.-]{0,}')),
				nullifna(SUBSTRING(lower(`unauthuser`), '^[A-Za-z0-9\\_\.-]{0,}')),
				ipstr(srcip)
			) AS user_src,
			`group`
		FROM
			$log
		WHERE
			$filter
	  	GROUP BY
	  		cal_time,
	  		`catdesc`,
	  		`hostname`,
			KCSIE_CONTENT,
	  		user_src,
			`group`
	  	/*SkipSTART*/
	  	ORDER BY
	  		cal_time
	  	/*SkipEND*/
	)### t
WHERE
	user_src IS NOT NULL
AND
	KCSIE_CONTENT IS NOT NULL
GROUP BY
	user_src,
    SLD,
	KCSIE_CONTENT,
	cal_time,
	`group`
ORDER BY
	cal_time ASC