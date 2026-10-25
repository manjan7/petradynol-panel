#!/bin/bash
#
# Standalone non-interactive installer for the Pterodactyl panel.
# Reverse-engineered from pterodactyl-installer/pterodactyl-installer (panel.sh)
# by pre-setting every variable the interactive installer asks for, so no
# prompts are shown. Run as root on Ubuntu 22.04 / 24.04 (or Debian 12/13).
#
# Usage:
#   sudo bash install-petradynol-panel.sh
#
# Override any value with environment variables before running, e.g.:
#   sudo FQDN=panel.example.com user_password=Secret123 bash install-petradynol-panel.sh

set -e -o pipefail

# ---------- Configuration (edit these) ----------
FQDN="${FQDN:-localhost}"
email="${email:-admin@example.com}"
user_email="${user_email:-admin@example.com}"
user_username="${user_username:-admin}"
user_firstname="${user_firstname:-Admin}"
user_lastname="${user_lastname:-User}"
user_password="${user_password:-adminpassword}"
MYSQL_DB="${MYSQL_DB:-panel}"
MYSQL_USER="${MYSQL_USER:-pterodactyl}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-pterodactyl}"
ASSUME_SSL="${ASSUME_SSL:-false}"
CONFIGURE_LETSENCRYPT="${CONFIGURE_LETSENCRYPT:-false}"
CONFIGURE_FIREWALL="${CONFIGURE_FIREWALL:-false}"
timezone="${timezone:-UTC}"
telemetry="${telemetry:-false}"
GITHUB_SOURCE="${GITHUB_SOURCE:-v1.4.0}"
# ------------------------------------------------

export FQDN email user_email user_username user_firstname user_lastname user_password
export MYSQL_DB MYSQL_USER MYSQL_PASSWORD
export ASSUME_SSL CONFIGURE_LETSENCRYPT CONFIGURE_FIREWALL timezone telemetry
export GITHUB_SOURCE SCRIPT_RELEASE="${GITHUB_SOURCE}"
export GITHUB_BASE_URL="https://raw.githubusercontent.com/pterodactyl-installer/pterodactyl-installer"

# Download lib.sh then the panel installer
curl -fsSL -o /tmp/lib.sh "$GITHUB_BASE_URL/$GITHUB_SOURCE/lib/lib.sh"
curl -fsSL -o /tmp/panel.sh "$GITHUB_BASE_URL/$GITHUB_SOURCE/installers/panel.sh"

# Source lib.sh so panel.sh finds lib_loaded
# shellcheck disable=SC1091
source /tmp/lib.sh

# Run the panel installer non-interactively (all vars already exported above)
bash /tmp/panel.sh

echo "=================================================="
echo "Pterodactyl panel installed!"
echo "URL:      http://${FQDN}/"
echo "Admin:    ${user_email} / ${user_password}"
echo "DB:       ${MYSQL_DB} (${MYSQL_USER})"
echo "=================================================="
