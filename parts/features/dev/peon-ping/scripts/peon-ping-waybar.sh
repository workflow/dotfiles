if peon status 2>/dev/null | grep -q "^peon-ping: active"; then
	printf '{"alt":"on","class":"on"}\n'
else
	printf '{"alt":"off","class":"off"}\n'
fi
