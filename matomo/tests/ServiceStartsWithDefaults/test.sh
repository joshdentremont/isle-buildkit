#!/command/with-contenv bash
# shellcheck shell=bash

# shellcheck disable=SC1091
source /usr/local/share/isle/utilities.sh

# Exit non-zero if database does not exist.
cat <<-EOF | execute-sql-file.sh
	use ${DB_NAME}
EOF

# Wait for access
wait_20x http://localhost:80/index.php

# All tests were successful
exit 0
