#!/run/current-system/sw/bin/sh/
cd /proc
echo "  count  pid"
ls -d [1-9]*/fd/* 2>/dev/null | sed 's/\/fd.*$//' | uniq -c | sort -rn
