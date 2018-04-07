#!/bin/sh
root="$DIST"
echo "<ul>"
for file in "$root"/*; do
  parentpath="${file#*/}"
  parent="${parentpath%/*}"
  filename="${file##*/}"
  if [[ -z $oldparent ]]; then
    echo "  <li> $parent </li>" && oldparent="$parent"
    echo "  <ul>"
  elif [[ $oldparent != $parent ]]; then
    echo "  </ul>"
    echo "  <li> $parent </li>" && oldparent="$parent"
    echo "  <ul>"
  fi
  echo "    <li><a href=\"$parentpath\">$filename</a></li>"
done
echo "  </ul>"
echo "</ul>"


