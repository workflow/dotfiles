# Thunderbolt Dock on Lenovo

https://gist.github.com/kyokley/169646c27ed2dcc470b6

# Fixing wifi disconnects on kernel 5.x

Change AP beacon int from 100ms to 50ms
Check with: `iw wlp3s0 link`

Disable IPv6 for affected connection manually in NM (set mode to "Ignore")

More Info: https://bugzilla.kernel.org/show_bug.cgi?id=203709
