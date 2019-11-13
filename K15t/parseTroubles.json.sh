#!/bin/bash

# parseTroubles.json.sh v1.0
#
# REVISION HISTORY
#
# v1.0 - Introduction of script.
#
# The following was written by Jason Epel to output a csv and Jira description in markdown format of the same K15t
# error data showing the source Jira project key that generated the error.
#
# For more information, see https://github.com/dharmaje/atlassian-tips-and-scripts
#
##################################################################################################################

# Check for presence of jq and trigger error if it isn't found. 
if ! [ -x "$(command -v jq)" ]; then
  echo 'ERROR: jq is not installed.  See https://stedolan.github.io/jq/' 
  exit 1
fi

# Check for presence of troubles.json before continuing; otherwise, generate error if it isn't present.
if [ -f troubles.json ]; then

	# Check for existnce of K15t_base_URL to use in HREF markdown.  If it isn't present generate output without the HREF.

	if [[ -z "${K15t_base_URL}" ]]; then
		echo
		echo INFORMATION:  In order to generate Jira markdown with the URL for the referenced Jira key, you need to
		echo set the environment variable K15t_base_URL = to the base URL for the Jira cloud instance.
		echo 
		echo EXAMPLE:  export K15t_base_URL=\"https://tenant.atlassian.net\"
		echo 
	fi
	
	echo "Parsing troubles.json"

	cat troubles.json | jq -r '. | map([.remoteIssueKey, .categoryName] | join(",")) | join("\n")' | sort | uniq > tmp.csv

	echo "||source Jira key||error message||" > jiraDescriptionMarkdown.txt
	while read row; do
		echo $row > tmp.txt
		k15tKey=$(cut -d',' -f1 tmp.txt)
		k15tError=$(cut -d',' -f2 tmp.txt)
		if [[ -z "${K15t_base_URL}" ]]; then
			echo "|$k15tKey|$k15tError|" >> jiraDescriptionMarkdown.txt
				else
			echo "|[$k15tKey|${K15t_base_URL}/browse/$k15tKey]|$k15tError|" >> jiraDescriptionMarkdown.txt
		fi
	done < tmp.csv

	echo """source Jira key"",""error message""" > output.csv
	cat tmp.csv >> output.csv
	rm tmp.csv tmp.txt
	open jiraDescriptionMarkdown.txt
	open output.csv

else
    echo "ERROR: troubles.json is missing."
	exit 1
fi
