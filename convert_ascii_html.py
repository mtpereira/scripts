#!/usr/bin/env python

import HTMLParser
import sys

with open(sys.argv[1], 'r') as f:
    html_ascii = f.read().decode("%s" % sys.argv[2])
    h = HTMLParser.HTMLParser()
    html_string = h.unescape(html_ascii)
    print html_string.encode(sys.argv[2])

# vim: set ts=4 sw=4 tw=0 et :
