_**Disclaimer: These reports are not supported by Fortinet.**_

---

# FortiAnalyzer Safeguarding Reports
## Overview
The changes made to the regulations for Keeping Children Safe in Education (KCSIE) in June 2023 were officially enforced in September 2023, requiring educational establishments to put more detailed filtering and monitoring solutions in place.

This has led to many establishments that use FortiAnalyzer as a reporting tool spending time/money customising the default safeguarding reports, creating custom reports or looking towards safeguarding specific products that have to run in tandem with FortiAnalyzer.

To combat this, I have created three reports for the FortiAnalyzer that I believe, combined, meet the 2023 KCSIE regulations.

A PDF sample of each report can be found in the Sample Reports folder.

## Important Announcement

As of FortiOS 7.4.4, all FortiGate models with 2GB or less of RAM are [no longer able to utilise proxy features](https://docs.fortinet.com/document/fortigate/7.4.0/new-features/519079/proxy-related-features-no-longer-supported-on-fortigate-2gb-ram-models-7-4-4).

No functionality has been lost from this change (safe search enforcement has been added to flow-mode web filter profiles) but all search phrase logging will have to be done via the application control method (detailed below) for the affected models.

## Table of Contents
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

## Usage
### FortiGate Prerequisites
The reports are designed to be as plug-and-play as possible and will work out-of-the-box. However, depending on your FortiGate's configuration, the following may not be present in the reports:
1. Usernames (falls back to IP addresses).
2. Search phrases entered into search engines.

#### Enabling Usernames
To have usernames present in the reports, FortiGate must be aware of what users are on the network via some form of authentication. This is usually done via [Fortinet SSO](https://docs.fortinet.com/document/fortigate/7.2.6/administration-guide/450337/fsso) or [Radius SSO](https://docs.fortinet.com/document/fortigate/7.2.6/administration-guide/513092/configuring-radius-sso-authentication) for local users using establishment owned equipment, as these are transparent to the users.

Please note that there are multiple ways of implementing Fortinet SSO and that you should contact your Fortinet account team to help you understand which one is the best suited to your environment.

For BYOD devices, I would also recommend contacting your Fortinet account team if you're unsure how to onboard them. This is largely reliant on your environment, so there is no "one-solution-fits-all."

#### Enabling Search Phrases
Search phrase logging is the easier of the two to implement and can be done via an application control profile or web filter profile, in tandem with a deep packet inspection profile, that is applied to the relevant firewall policies.

Implementing search phrase logging via an application control profile allows for the capture of search phrases entered into Google, Bing and DuckDuckGo with minimal configuration. It only requires that the General Interest section within the profile is set to `Monitor`.

If this generates too many logs, you can narrow the scope of this monitor to search phrases only by setting the General Interest category to `Allow` and creating an Application and Filter Override with all application signatures containing `Search.Phrase` to `Monitor`.

Alternatively, implementing search phrase logging via a web filter profile allows for the capture of search phrases entered into Google, Bing, Yahoo and Yandex, by default.

This method requires a web filter profile to be running the *proxy feature set* with `Log all search keywords` enabled.

Note that this means that the relevant firewall policies will also have to be running in proxy mode.

##### Search Phrase Logging - Adding Additional Search Engines

_\[NOTE\]: For anyone running multiple VDOMs, the following changes must be performed within the relevant traffic VDOMs. Performing this configuration within the global settings does not seem to have any effect (tested with FOS 7.2.7)._

As noted above, FortiGate's web filter can only log search phrases entered into Google, Bing, Yahoo and Yandex by default. However, it's possible to expand this list via the CLI.

To see what search engines are currently logging search phrases, open a CLI interface and enter the command: `show webfilter search-engine`. All the search engines displayed with the query field set are capable of logging search phrases from their corresponding web apps.

Adding a search engine is then a simple case of entering `config webfilter search-engine`, `edit`ing the search engine you want to add and filling out the regex for the necessary fields.

As an example, I added DuckDuckGo as a search engine.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/44c4884c-8fab-4740-8ea6-e5a4afedce2d)

It can be a tad tricky to get certain characters (read: “question marks”) into these configs. The best way I found to do this without having to reboot the box was to create a one-time automation stitch with a CLI script as the action.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/8ce4a69b-fc23-4519-80c8-d3a09c04af0c)

### Importing the Reports
To get started with using these reports, you will need to have a FortiAnalyzer running either 7.4.0 or later, excluding 7.4.1 (there is a bug within 7.4.1 that prevents custom datasets from being imported/edited). 7.4.0+ has a neutrino style GUI, so be sure to re-familiarise yourself with the system if you're upgrading from 7.2.x or below.

Importing the reports is as simple as cloning this repo or downloading the .dat files within the Importable Reports directory, navigating to `Reports > Report Definitions > More > Import` and selecting the .dat files to upload.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/68d2ca78-b40e-4c94-b5ef-4c30650dddb4)

Once imported, please ensure that the Overview report and the User-Specific Context Report are set to landscape mode. This can be done by editing the relevant reports, navigating to their `Settings` at the top, expanding the `Advanced Settings` tab at the bottom of the page, and selecting `Landscape`.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/4843e605-c455-4d05-a841-5ec889e60e97)

To keep things clean, I recommend creating a reports folder for all default reports and moving all the default _black_ folders/reports into it, as green folders cannot be moved (not present in some versions). Once done, create another folder for KCSIE reports and move these reports into it (see above screenshot for how this tidies things up).

### Customising the Cover Page
The cover page configuration for each report can be found within their respective advanced settings. These can be accessed by editing the report, navigating to `Settings` at the top and expanding the `Advanced Settings` tab at the bottom of the page. The cover page settings can then be found by clicking the `Edit Cover Page` button.

![Screenshot 2024-03-25 120055](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/9c579664-0f17-4efe-9bbe-196029573759)

This will provide a menu where the background image, title, title colour, footer text, etc. can be customised.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/f66d1702-1b70-4a17-9c94-017fb8cdb3e3)

In the case of the Overview report, the preview may look a tad squashed. This is normal for landscape reports, as the preview can only render portrait cover pages.

### Setting the Time Period
When running a safeguarding report, it's important to select the correct time period for the report to run over. FortiAnalyzer provides a variety of pre-defined relative timeframes that can be used, but it's important to understand that the options starting with "Previous," do not include the current period.

For example, "Previous 4 Hours" will not include the current hour, "Previous 7 Days" will not include today, and "Previous Week" will not include the current week (Mon-Sun).

### Running Reports on a Schedule
To run a report on a schedule, simply edit the report, navigate to `Settings` at the top, check the box next to `Enable Schedule` and fill out the relevant settings.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/cad18b09-f8f7-4713-95ba-407d3e4ef92a)

If you need a report to run on multiple schedules (e.g. the Overview report to run both once per month and once per week to display different levels of trends), the report will have to be cloned and each report's time period and schedule configured separately.

#### Automatically Email Scheduled Reports to DSL Teams
To have scheduled reports automatically emailed to the DSL teams the email server settings on FortiAnalyzer must be configured. This is done under `System Settings > Advanced > Mail Server`.

Once the email server has been configured, output profiles will need to be created under `Reports > Advanced Settings > Output Profile`. These output profiles dictate the format of the emailed report alongside the subject, body and recipients of the email.

There is also the option to upload generated reports so an FTP or SCP server, if desired.

### Overview Report - Filtering Results to a Specific User Group
If your FortiGate is using role-based access control (RBAC) to provide different groups of students with different web filter profiles, the group that the user belongs to in the firewall policy they pass through will be logged. This makes it possible for a group filter to be set within the Overview report.

To do this, simply edit the Overview report, navigate to its `Settings` at the top, open the `Filters` dropdown and add a `filter` based on the group log field.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/cd91b285-ae93-4134-814f-e053d66a4ed7)

If more than one group needs to be matched, simply change the `Log messages that match` to `Any of the Following Conditions` and add more `group` filters.

### User Reports - Setting the User or IP Address
To set the username or IP address that you want a user report to run against, edit the report, navigate to `Settings` at the top, open the `Filters` drop down and add a `User (user)` filter.

![image](https://github.com/QuietCoderBoi/FortiAnalyzer-Safeguarding-Reports/assets/67976682/66380372-3492-4c8d-b83d-4c212d07c885)

**_This username is case-sensitive and must be entered exactly as it appears in the in the logs._**
