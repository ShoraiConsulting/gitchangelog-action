# Create release on tag push

This Action automatically creates a GitHub release when new tag is pushed. Release notes are obtained via [gitchangelog](https://github.com/vaab/gitchangelog).

## Usage

```workflow
name: Generate release with changelog
on:
  push:
    tags:
      - '*'

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v2
      with:
          fetch-depth: 0
    - name: Fetch all tags
      run: git fetch --depth=1 origin +refs/tags/*:refs/tags/*
    - name: Push release
      uses: ynd-consult-ug/gitchangelog-action@v1.0.1
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        TAG_NAME: ${{ github.ref }}
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

## See also

Image on Docker Hub: [yndconsult/gitchangelog-action](https://hub.docker.com/r/yndconsult/gitchangelog-action).
