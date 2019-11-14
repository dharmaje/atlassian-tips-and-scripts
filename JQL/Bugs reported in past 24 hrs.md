Bugs reported in past 24 hrs

~~~
issuetype = bug AND created > -1d
~~~

Want to know when new bugs have been created in a Jira backlog?  Here's a simple Jira query that can be used to trigger daily email alerts via a filter subscription that runs every 24 hours.  You can also add more qualifying criteria to the query so it will only include issues that were recently transitioned into a ready status in the past 24 hours, using an updated instead of created field and related historical and current status conditions (e.g., status was "To do" and status = "Open" depending on your workflow).

One can also create a Jira webhook to Slack with more specific constraints so that only sev 1 bugs, for example, will generate an alert that can appear in a shared Slack channel.
