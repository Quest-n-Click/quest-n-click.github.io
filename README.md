# quest-n-click.github.io

The demo host of [Quest'n'Click](https://github.com/Quest-n-Click). The website is <https://quest-n-click.cleverapps.io> ([its repository](https://github.com/Quest-n-Click/quest-n-click-site)); this one serves the builds it embeds.

| Path | What | Comes from |
|---|---|---|
| `/` | a redirect to the website | `site/index.html` |
| `/play/` and `/play/studio.html` | the sample game and the Studio demo | the engine's latest **signed** release tag, built by `scripts/build.sh` |
| `/docs/<version>/` | versioned documentation | the engine's released docs archives, checked against their sums and attestations |

Merging a pull request to `main` deploys.

## Full build

Node 22, git and the GitHub CLI (`gh auth login`):

```bash
scripts/build.sh            # latest engine release; or scripts/build.sh v4.5.1
python3 -m http.server -d out 8000
```

The engine tag must be signed by a key in `allowed_signers` (this repository's copy is the trust root). A new
engine release triggers a rebuild through an `engine-release` dispatch; `Actions → deploy → Run workflow` does it by hand.

Contributing: see the organization's [CONTRIBUTING](https://github.com/Quest-n-Click/.github/blob/main/CONTRIBUTING.md).
