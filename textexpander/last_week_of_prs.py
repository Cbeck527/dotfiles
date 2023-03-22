import datetime
import json
import textwrap
import urllib2

GITHUB_PERSONAL_TOKEN = '[redacted]'
GITHUB_USERNAME = '[redacted]'

headers = {'Authorization': "token {}".format(GITHUB_PERSONAL_TOKEN)}
one_week_ago = (datetime.date.today() - datetime.timedelta(weeks=1)).strftime('%Y-%m-%d')
search_url = (
    'https://api.github.com/search/issues'
    '?q=is:pr+author:{github_username}+created:>={one_week_ago}'.format(
        one_week_ago=one_week_ago,
        github_username=GITHUB_USERNAME,
    )
)

req = urllib2.Request(
    search_url.format(search_url),
    headers=headers
)
response = urllib2.urlopen(req)
response_json = json.loads(response.read())

for item in response_json.get('items'):
    markdown_string = textwrap.dedent(
    """
    * {title} - {url}
    {body}
    """
    )
    print(markdown_string.format(
        title=item.get('title'),
        body="\n".join("  " + line for line in item.get('body').splitlines()),
        url=item.get('pull_request').get('html_url'),
    ))
