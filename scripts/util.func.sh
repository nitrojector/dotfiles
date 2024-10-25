log7() {
	local BASE_DIR="$HOME/log"
	local LOG_FILE="${BASE_DIR}/$1.log"

	mkdir -p ${BASE_DIR}
	touch ${LOG_FILE}

	echo "[$(date +'%Y-%m-%d %H:%M:%S')] $2" >> ${LOG_FILE}
}

