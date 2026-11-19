#!/usr/bin/env bash
# Runs once when the codespace is made: the book's R packages, in the exact versions of renv.lock, as Linux
# binaries from Posit Package Manager (minutes, not an hour of compiling). DataStep Studio for R itself is
# installed by the editor (devcontainer.json). What it did is written to ~/.datastep-r/setup.log.
set -uo pipefail

mkdir -p "$HOME/.datastep-r"
log="$HOME/.datastep-r/setup.log"
say() { echo "$(date -u +%H:%M:%S) $*" | tee -a "$log"; }

codename=$(. /etc/os-release && echo "${VERSION_CODENAME:-noble}")
export RENV_CONFIG_REPOS_OVERRIDE="https://packagemanager.posit.co/cran/__linux__/${codename}/latest"
export RENV_CONFIG_PAK_ENABLED=FALSE
say "R: $(R --version | head -1)"
say "Packages from ${RENV_CONFIG_REPOS_OVERRIDE}"

if Rscript -e 'renv::restore(prompt = FALSE)' >>"$log" 2>&1; then
  say "Packages: restored from renv.lock"
else
  say "Packages: renv::restore() did not finish; see $log. DataStep R: Check Setup lists what is missing."
fi

Rscript -e 'for (p in c("dplyr", "admiral", "pharmaversesdtm", "httpuv")) cat(p, as.character(packageVersion(p)), "\n")' 2>&1 | tee -a "$log"
say "Ready. Open START-HERE.md."
exit 0
