
#!/bin/bash

set -e
/usr/sbin/httpd -k start
tail -f /dev/null
#exec "apache2-foreground"
