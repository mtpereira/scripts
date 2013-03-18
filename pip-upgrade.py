#!/usr/bin/env python

import pip
from subprocess import call

local = []
managed = []

for package in pip.get_installed_distributions(): 
    if package.location.find("/usr/local", 0) != -1:
        print "%s is local (%s), update" % (package.project_name, package.location)
        local.append(package.project_name)
    else:
        print "%s is managed (%s), upgrade using your package manager" % (package.project_name, package.location)
        managed.append(package.project_name)

for package in local:
    print "Upgrading %s ..." % package
    call("pip install --upgrade %s" % package, shell=True)

print "The following packages were not installed by pip, please use your package manager to upgrade them."
print " ".join(managed)

