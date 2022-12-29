#!/bin/bash
for i in `ps -ef| grep -v UID | grep /usr/lib/chromium-browser/chromium-browser | awk '{print $2}' ` ; do echo $i; kill $i ;  done
