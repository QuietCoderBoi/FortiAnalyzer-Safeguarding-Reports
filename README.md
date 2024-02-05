_**Disclaimer: These reports are not supported by Fortinet and are maintained in my spare time. I do my best to keep them up-to-date but changes may be slow.**_

---

# FortiAnalyzer Safeguarding Reports
## Overview
The changes made to the regulations for Keeping Children Safe In Education (KCSIE) in June 2023 were officially enforced in September 2023, requiring educational establishments to put more detailed filtering and monitoring solutions in place. This has led to many establishments using FortiAnalyzer as a reporting tool spending time/money customising the default safeguarding reports, creating custom reports or looking towards safeguarding specific products that have to run in tandem with FortiAnalyzer.

To combat this, I have created three reports for the FortiAnalyzer that I believe, combined, meet the 2023 KCSIE regulations.

A PDF sample of each report can be found in the Sample Reports folder.

## Table of Contents
- [Report Descriptions](#report-descriptions)
  - [Overview Report](#overview-report)
  - [User Drilldown Report](#user-drilldown-report)
  - [User Full Browsing and Search History Report](#user-full-browsing-and-search-history-report)
- [Usage](#usage)
  - [FortiGate Prerequisites](#fortigate-prerequisites)
    - [Enabling Usernames](#enabling-usernames)
    - [Enabling Search Phrases](#enabling-search-phrases)
      - [Search Phrase Logging - Adding Additional Search Engines](#search-phrase-logging---adding-additional-search-engines)
  - [Importing the Reports](#importing-the-reports)
  - [Customising the Cover Pages](#customising-the-cover-page)
  - [Setting the Time Period](#setting-the-time-period)
  - [Running Reports on a Schedule](#running-reports-on-a-schedule)
    - [Automatically Email Scheduled Reports to DSL Teams](#automatically-email-scheduled-reports-to-dsl-teams)
  - [Overview Report - Filtering Results to a Specific User Group](#overview-report---filtering-results-to-a-specific-user-group)
  - [User Reports - Setting the User or IP Address](#user-reports---setting-the-user-or-ip-address)

## Report Descriptions
Please note that these reports currently only work with FortiGate logs and are based off of the FortiGate's web filter functionality.

### Overview Report
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

Finally, at the bottom of the report, there is the Full Search Term History. This, very simply, provides a list of all the keywords logged by the FortiGate within the time period the report is run over and lists them in chronological order (i.e. by when they were searched).

### User Full Browsing and Search History Report
During the creation of the User Drilldown report, I noticed that it was very hard to correlate events happening between different web filter categories and/or keyword search times. Since context is one of the most important aspects when determining whether a potential incident needs actioning I decided to create a supplement report: the User Full Browsing & Search History report.

This report is incredibly simple. It lists _**all**_ the user's web activity during the time period the report is run over in chronological order. All keyword searches are included and any activity that violates one of the KCSIE categories is denoted by an entry in the KCSIE Category column.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/e1ac42fb-7bf0-444f-8bf2-c41cab35886b)

## Usage
### FortiGate Prerequisites
The reports are desgined to be as plug-and-play as possible and will work out-of-the-box. However, depending on your FortiGate's configuration, the following may not be present in the reports.
1. Usernames (falls back to IP addresses).
2. Search phrases entered into search engines.

#### Enabling Usernames
To have usernames present in the reports, the FortiGate must be aware of what users are on the network via some form of authentication. For local users using establishment owned equipment, this is usually done via [Fortinet SSO](https://docs.fortinet.com/document/fortigate/7.2.6/administration-guide/450337/fsso) or [Radius SSO](https://docs.fortinet.com/document/fortigate/7.2.6/administration-guide/513092/configuring-radius-sso-authentication), as these are transparent to the users.

Please note that there are multiple ways of implementing Fortinet SSO and that you should contact your Fortinet account team to help you understand which one is the best suited to your environment.

For BYOD devices, I would also recommend contacting your Fortinet account team if you're unsure how to onboard them. This is largely reliant on your environment so there is no, "one-solution-fits-all."

#### Enabling Search Phrases
Search phrase logging is the easier of the two to implement. It simply requires a deep packet inspection profile and a web filter profile running the proxy feature set with `Log all search keywords` enabled on the firewall policy that the students' traffic is passing through. This will log all search phrases entered into Google, Yahoo, Bing and Yandex.

Note that this also requires the firewall policy to be running in proxy-based inspection mode.

##### Example Firewall Policy
###### Policy Table View
![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/f0e536b5-0118-4d17-b64c-0b97b5d11e81)

###### Policy Settings
![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/dd8904e8-4ae7-450e-94ae-c7ec878b30b6)
![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/c84aab29-d0fb-4601-ae82-b6c54074cb2e)
![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/7a99ab49-dd51-4509-8383-56ef6bb7beae)

###### Web Filter Profile Settings
![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/6a46de0f-d0ef-4e0b-8919-cea415f1bd42)
![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/5dab41e3-c078-4820-b9f5-6c610f382225)

##### Search Phrase Logging - Adding Additional Search Engines
As noted above, FortiGate's web filter can only log search phrases entered into Google, Bing, Yahoo and Yandex by default. However, it's possible to expand this list via the CLI.

To see what search engines are currently logging search phrases, open a CLI interface and enter the command: `show webfilter search-engine`. All the search engines displayed with the `query` field set are capable of logging search phrases from their corresponding web apps.

Adding a search engine is then a simple case of entering `config webfilter search-engine`, `edit`ing the search engine you want to add and filling out the regex for the necessary fields. As an example, I added DuckDuckGo as a search engine.
![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/44c4884c-8fab-4740-8ea6-e5a4afedce2d)

It can be a tad tricky to get certain characters (read, "question marks") into these configs. The best way I found to do this without having to reboot the box was to create a one-time automation stitch with a CLI script as the action.
![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/8ce4a69b-fc23-4519-80c8-d3a09c04af0c)

### Importing the Reports
To get started with using these reports, you will need to have a FortiAnalyzer running either 7.4.0 or later, excluding 7.4.1 (there is a bug within 7.4.1 that prevents custom datasets from being imported/edited). 7.4.0+ has a neutrino style GUI so be sure to re-familiarise yourself with the system if you're upgrading from 7.2.x or below.

Importing the reports is as simple as cloning this repo, or downloading the .dat files within the Importable Reports directory, navigating to `Reports > Report Definitions > More > Import` and selecting the .dat files to upload.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/68d2ca78-b40e-4c94-b5ef-4c30650dddb4)

To keep things clean, I recommend creating a reports folder for all default reports and moving all the default **_black_** folders/reports into it: green folders cannot be moved (not present in some versions). Once done, create another folder for KCSIE reports and move these reports into it (see above screenshot to how this tidies things up).

### Customising the Cover Page
The cover page configuration for each report can be found within their respective advanced settings. These can be accessed by editing the report, navigating to `Settings` at the top and expanding the Advanced Settings tab at the bottom of the page. The cover page settings can then be found by clicking the `Edit Cover Page` button.

![Untitled](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/c2496d03-90ef-45d9-9b13-0ebad32fbdd0)

This will provide a menu where the background image, title, title colour, footer text, etc. can be customised.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/4a5e5713-04c7-4c71-a491-627cad828763)

In the case of the Overview report the preview may look a tad squashed but this is normal for landscape reports, as the preview can only render portrait cover pages.

### Setting the Time Period
When running a safeguarding report, it's important to select the correct time period for the report to run over. FortiAnalyzer provides a variety of pre-defined relative timeframes that can be used but it's important to understand that the options starting with, "Previous," do not include the current period.

For example, "Previous 4 Hours," will not include the current hour, "Previous 7 Days," will not include today and, "Previous Week," will not include the current week (Mon-Sun).

### Running Reports on a Schedule
To run a report on a schedule simply edit the report, navigate to `Settings` at the top, check the box next to `Enable Schedule` and fill out the relevant settings.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/cad18b09-f8f7-4713-95ba-407d3e4ef92a)

If you need a report to run on multiple schedules (e.g. the Overview report to run both once per month and once per week to display different levels of trends) the report will have to be cloned and each report's time period and schedule configured separtely.

#### Automatically Email Scheduled Reports to DSL Teams
To have scheduled reports automatically emailed to the DSL teams the email server settings on FortiAnalyzer must be configured. This is done under `System Settings > Advanced > Mail Server`.

Once the email server has been configured, output profiles will need to be created under `Reports > Advanced Settings > Output Profile`. These output profiles dictate the format of the emailed report alongside the subject, body and recipients of the email.

There is also the option to upload generated reports so an FTP or SCP server, if desired.

### Overview Report - Filtering Results to a Specific User Group
If your FortiGate is using role-based access control (RBAC) to provide different groups of students with different web filter profiles then the group that the user belongs to in the firewall policy they pass through will be logged. This makes it possible for a `group` filter to be set within the Overview report.

To do this, simply edit the Overview report, navigate to it's `Settings` at the top, open the `Filters` dropdown and add a filter based on the `group` log field.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/cd91b285-ae93-4134-814f-e053d66a4ed7)

If more than one group needs to be matched, simply change the `Log messages that match` to `Any of the Following Contitions` and add more `group` filters.

### User Reports - Setting the User or IP Address
To set the username or IP address that you want a user report to run against, edit the report, navigate to `Settings` at the top and fill in the `User or IP` box.

![Untitled](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/d3ed148d-8bdb-4848-9f99-ec76ab992d26)

**_The username is case sensitive and must be entered exactly as it appears in the Overview report or in the logs._**
