#!/bin/sh
set -eu

html-minifier --remove-tag-whitespace --remove-attribute-quotes --minify-css true --collapse-boolean-attributes --collapse-inline-tag-whitespace --collapse-whitespace index.source.html > index.html

for quality in $(seq 0 11); do
  for window in $(seq 10 24); do
    z_window=$(printf "%02d" $window)
    z_quality=$(printf "%02d" $quality)
    brotli -k -q $quality -w $window  < index.html > index.html.$z_quality.$z_window.brx
  done
done

file=$(du -bs *.brx | sort -n | head -1 | cut -d$'\t' -f2)

echo "--> $file"
mv "$file" index.html.br
rm *.brx