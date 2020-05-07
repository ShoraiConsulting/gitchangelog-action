# Assign reviewers based on assignees

If your team currently uses pull request assignees but would like to switch to  [Review Requests](https://blog.github.com/2016-12-07-introducing-review-requests/), having everyone change their workflows can be difficult. This GitHub Action eases the transition by automatically creating and deleting review requests based on assignees. This may be particularly helpful when using a 3rd-party app like [Pull Reminders](https://pullreminders.com) that relies on review requests.

## Usage

This Action subscribes to [Pull request events](https://help.github.com/en/articles/events-that-trigger-workflows#pull-request-event-pull_request) specifically the `assigned` and `unassigned` events which fire whenever users are assigned or unassigned to pull requests.

```workflow
name: Generate release with changelog
on:
  create:
    tags:
      - v*

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Fetch all tags
      run: git fetch --depth=1 origin +refs/tags/*:refs/tags/*
    - name: Push release
      uses: ynd-consult-ug/gitchangelog-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        TAG_NAME: ${{ github.ref }}

```


## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
