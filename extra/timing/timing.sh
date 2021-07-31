#!/usr/bin/env bash

ARG="${1:-1}"
ROWS="key mod2 mod4 mod8 mod16 mod4i mod8i mod16i"
RED='\033[0;31m'
NC='\033[0m'

[[ "$ARG" =~ ^1|2$ ]] || {
  echo "Invalid argument $ARG"
  exit 0
}

if [[ "$ARG" -eq 1 ]]; then
  for i in $ROWS; do
    echo -e "${RED}Running exact match for row $i${NC}"
    read -r -d '' SCRIPT <<-EOF
	set linesize 132;
	EXPLAIN PLAN FOR
	SELECT key
	FROM performance_testing
	WHERE $i = 5;

	SELECT plan_table_output
	FROM TABLE(dbms_xplan.display());
	
	SET TIMING ON;
	SELECT key
	FROM performance_testing
	WHERE $i = 5;
	
	QUIT
	EOF
    sqlplus -S pdbadmin/password@northwind <<< "$SCRIPT" | grep -E '^([|]|Elapsed)'
  done
fi

if [[ "$ARG" -eq 2 ]]; then
  for i in $ROWS; do
    echo -e "${RED}Running range for row $i${NC}"
    read -r -d '' SCRIPT <<-EOF
	set linesize 132;
	EXPLAIN PLAN FOR
	SELECT key
	FROM performance_testing
	WHERE $i BETWEEN 800 AND 900;

	SELECT plan_table_output
	FROM TABLE(dbms_xplan.display());
	
	SET TIMING ON;
	SELECT key
	FROM performance_testing
	WHERE $i BETWEEN 800 AND 900;
	
	QUIT
	EOF
    sqlplus -S pdbadmin/password@northwind <<< "$SCRIPT" | grep -E '^([|]|Elapsed)'
  done
fi
