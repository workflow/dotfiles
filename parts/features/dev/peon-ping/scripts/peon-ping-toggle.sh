if peon status 2>/dev/null | grep -q "^peon-ping: active"; then
	peon pause
	peon notifications off
else
	peon resume
	peon notifications on
fi
