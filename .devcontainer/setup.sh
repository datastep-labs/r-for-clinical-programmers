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

# System libraries that the Linux binaries of the locked packages need (fs: libuv, V8: libnode, ragg: freetype, ...).
# Made with pak::pkg_sysreqs(names(renv::lockfile_read("renv.lock")$Packages)) on Ubuntu 24.04; make it again when
# renv.lock gets a package with new system needs.
sysreqs="libnode-dev libx11-dev libcurl4-openssl-dev libssl-dev cmake make libuv1-dev libfreetype6-dev zlib1g-dev
  libjpeg-dev libpng-dev libtiff-dev libwebp-dev libicu-dev libfontconfig1-dev libfribidi-dev libharfbuzz-dev libxml2-dev"
if sudo -n apt-get -qq update >>"$log" 2>&1 && sudo -n apt-get -y -qq install $sysreqs >>"$log" 2>&1; then
  say "System libraries: installed"
else
  say "System libraries: apt-get did not finish; see $log"
fi
say "Packages from ${RENV_CONFIG_REPOS_OVERRIDE}"

ok=1
if Rscript -e 'renv::restore(prompt = FALSE)' >>"$log" 2>&1; then
  say "Packages: restored from renv.lock"
else
  ok=0
  say "Packages: renv::restore() did not finish; see $log"
fi

Rscript -e 'for (p in c("dplyr", "admiral", "pharmaversesdtm", "httpuv")) cat(p, as.character(packageVersion(p)), "\n")' 2>&1 | tee -a "$log" || ok=0
if [ "$ok" = 1 ]; then
  say "Ready. Open START-HERE.md."
else
  say "The setup did not finish. Open START-HERE.md, stop 1: DataStep R: Check Setup lists what is missing, with the fix."
fi
exit 0
