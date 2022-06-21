FROM python:alpine

LABEL repository="http://github.com/ShoraiConsulting/gitchangelog-action"
LABEL homepage="http://github.com/ShoraiConsulting/gitchangelog-action"
LABEL "com.github.actions.name"="Gitchangelog Action"
LABEL "com.github.actions.description"="Generate gitchangelog for newly created tag and release it"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="purple"

RUN apk add --no-cache bash git jq curl

RUN pip3 install gitchangelog

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
