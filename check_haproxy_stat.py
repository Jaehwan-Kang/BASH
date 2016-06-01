#!/usr/bin/python
#
# Usage
# > python check_haproxy_stat.py [URL] [USER] [PASSWORD] [LISTENER]
#
# Example
# > python check_haproxy_stat.py 211.61.155.206:1936 cyebiz Cyebizadmin151 lg-homeboy01

import sys
from haproxystats import HAProxyServer

haproxy = HAProxyServer(sys.argv[1], sys.argv[2], sys.argv[3], timeout=3)

for b in haproxy.listeners:
    if b.name == sys.argv[4]:
        if b.status == "UP":
            print("%s : %s" % (b.name, b.status))
            sys.exit(0)  # Normal exit code
        elif b.status == "DOWN":
            print("%s : %s" % (b.name, b.status))
            sys.exit(2)  # Critical exit code
        else:
            print("UNKNOWN %s : %s" % (b.name, b.status))
            sys.exit(1)  # Warning exit code