# quest-n-click.github.io

The website of [quest'n'click](https://github.com/Quest-n-Click): <https://quest-n-click.github.io>.

| Path | What | Comes from |
|---|---|---|
| `/` | landing page | `site/` in this repository |
| `/play/` and `/play/studio.html` | the sample game and the Studio demo | the engine's latest **signed** release tag, built by `scripts/build.sh` |
| `/docs/<version>/` | versioned documentation | the engine's released docs archives, checked against their sums and attestations |

## Change the landing page

Edit `site/index.html` or `site/style.css`, then preview it:

```bash
python3 -m http.server -d site 8000   # http://localhost:8000 (the /play/ and /docs/ links need a full build)
```

Open a pull request: merging to `main` deploys.

## Full build

Node 22, git and the GitHub CLI (`gh auth login`):

```bash
scripts/build.sh            # latest engine release; or scripts/build.sh v4.5.1
python3 -m http.server -d out 8000
```

The engine tag must be signed by a key in `allowed_signers` (this repository's copy is the trust root). A new
engine release triggers a rebuild through an `engine-release` dispatch; `Actions → deploy → Run workflow` does it by hand.

Contributing: see the organization's [CONTRIBUTING](https://github.com/Quest-n-Click/.github/blob/main/CONTRIBUTING.md).
Screenshots and art are from the sample game, CC BY 4.0.
