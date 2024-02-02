Disclaimer: These reports are not supported by Fortinet and are maintained in my spare time. I do my best to keep them up-to-date but changes may be slow.

---

# FortiAnalyzer-Safeguarding-Reports
## Overview
The changes made to the regulations for Keeping Children Safe In Education (KCSIE) in June 2023 were officially enforced in September 2023, requiring educational establishments to put more detailed filtering and monitoring solutions in place. This has led to many establishments using FortiAnalyzer as a reporting tool spending time/money customising the default safeguarding reports, creating custom reports or looking towards safeguarding specific products that have to run in tandem with FortiAnalyzer.

To combat this, I have created three reports for the FortiAnalyzer that I believe, combined, meet the 2023 KCSIE regulations.

A PDF sample of each report can be found in the Sample Reports folder.

## Report Descriptions
Please note that these reports currently only work with FortiGate logs.

### Overview/High-Level Report
The Overview report is designed to provide a high-level overview of users' web activity.

It starts by showing the ratios of web filter violations based on the C's of online safety, as set out by the UK Safer Internet Centre (UKSIC), which I have dubbed, "KCSIE Categories." These violations are not necessarily blocked websites. They are any activity that is logged against a web filter category (i.e. any category whose action is not set to, "Allow") that is included in one of the KCSIE categories (details of which web filter categories are assigned to which KCSIE categories can be found in the Dataset Source directory).

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/6fe9513b-498e-4ff7-b395-3d09016b2229)

To the right of this, the top 10 web filter categories and top 10 websites that have been blocked/visited are grouped by KCSIE category and displayed to help access web browsing trends.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/d0bc77f4-8521-488a-a418-dbf3bd979d2b)

To suppliment this information, lists of the top 100 users that violate the KCSIE categories are provided.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/378b6981-5bc8-4da8-b904-1332d0d540ad)

The top 10 users of each of these lists then have their top 10 websites listed out for review.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/28b41270-53a4-43a7-bdaf-d28b9c01e960)

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/48ba8b8f-8fc1-4648-a7ee-dd78640ef178)

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/3a4c4852-4185-4994-8acb-79b8d9d8872d)

This should provide a basis for knowing if any repeat offenders need to be investigated further.

**Please note that if the FortiGate does not know the username of a user, it will fall back to using source IP addresses.**

### User Drilldown Report
The User Drilldown report gives a detailed view into the activities of a user within a specific time period, split out into an overview, KCSIE categories and web filter categories. It is designed to be exported in PDF format to make use of the interactive contents table and document outline menu, that most PDF readers provide.

The report begins by listing out the details of the user: their username (if known), all source IPs and all hostnames/MAC addresses that they used during the time period the report is run over.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/dc88904c-bb61-472e-98fd-f2764d867fc7)

It then looks at any applications blocked by FortiGate's application control to provide insight into any attempts to bypass the web filter.

The pie charts display all blocked applications, whilst details on blocked applications that can potentially be used to bypass the web filter are provided below.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/e6281881-ee10-4c05-9054-bdfaf85fa0eb)

The format of having a summary and details under a section title is proinent in this report so, it's important to know the difference between the summary and the details:
- The summary provides a list of applications/websites that have been used/visited and how many times they have been used/visited.<br>![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/dc92bf38-aea7-4d78-acb2-2c40e434b783)
- The details provide a list of each instance an application/website was used/visited with a timestamp next to each, in chronological order.<br>![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/1c533068-2ab7-4584-8695-8e2c5b30b2fe)

After blocked applications have been reviewed the web filter violations are displayed, starting with an overview page similar to that of the overview report.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/b36366e2-fdcb-4cc5-89c0-25220236c079)

The primary difference between this page and that of the overview report is that this page is not limited to top 10s. All web filter categories that have been blocked/visited within the KCSIE categories are displayed in the pie charts. This allows for categories of interest to be noted and navigated to in the next sections, the KCSIE category drilldowns.

The KCSIE category drilldowns list out all the web filter categories within them and provide summary and details tables for each (as noted in the comment on format earlier).

Finally, at the bottom of the report, there is the Full Search Term History. 

This, very simply, provides a list of all the keywords logged by the FortiGate within the time period the report is run over and lists them in chronological order (i.e. by when they were searched).
