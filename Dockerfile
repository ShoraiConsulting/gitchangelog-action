FROM python:alpine

LABEL repository="http://github.com/ynd-consult-ug/gitchangelog-action"
LABEL homepage="http://github.com/ynd-consult-ug/gitchangelog-action"
LABEL "com.github.actions.name"="Gitchangelog Action"
LABEL "com.github.actions.description"="Generate gitchangelog for newly created tag and release it"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="purple"

RUN apk add --no-cache -y bash git jq

RUN pip3 install -y gitchangelog

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
