#! /bin/sh
#
# watcher.sh
# Copyright (C) 2016 rharriso <rharriso@lappy>
#
# Distributed under terms of the MIT license.
#


while true; do
  change=$(inotifywait -e close_write **/*.d)
  change=${change#./ * }
  clear
  dub test
done
