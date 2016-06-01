#!/usr/bin/python
#
# Usage
# > python check_haproxy_stat.py [URL] [USER] [PASSWORD] [LISTENER]
#
# Example
# > python check_haproxy_stat.py 211.61.155.206:1936 cyebiz Cyebizadmin151 lg-homeboy01

import sys
from haproxystats import HAProxyServer

try:

    haproxy = HAProxyServer(sys.argv[1], sys.argv[2], sys.argv[3], timeout=3)
    for b in haproxy.listeners:
        if b.name == sys.argv[4]:
            if b.status == "UP":
                print("%s : %s" % (b.name, b.status))
                sys.exit(0)  # OK exit code
            elif b.status == "DOWN":
                print("%s : %s" % (b.name, b.status))
                sys.exit(2)  # Critical exit code
            else:
                print("UNKNOWN %s : %s" % (b.name, b.status))
                sys.exit(3)  # UNKNOWN exit code
        else:
            print("No Match Listener")
            sys.exit(3)

except IndexError as e:
    print("Wrong ARG : %s" % e)
    sys.exit(3)