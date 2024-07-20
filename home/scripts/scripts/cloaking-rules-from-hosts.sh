set -euo pipefail

awk 'NF >= 2 {for (i = 2; i <= NF; i++) print $i " " $1}' /etc/hosts
