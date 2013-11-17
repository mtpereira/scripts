#!/usr/bin/env python

"""Usage: ansible-dirs [-h] (playbook | role) <name> ...

Options:
  -h --help     show this help message and exit
  -v --verbose  verbose mode

"""
from sh import mkdir, touch, stat
from docopt import docopt

def create_playbook(books, play="site.yml"):
    for book in books:
        mkdir(book)
        mkdir(book + "/host_vars")
        mkdir(book + "/group_vars")
        mkdir(book + "/roles")
        touch(book + play)
        touch(book + "README.md")

def create_role(roles):
    for role in roles:
        mkdir("-p", "roles/" + role)
        mkdir("-p", "roles/" + role + "/files")
        mkdir("-p", "roles/" + role + "/defaults")
        mkdir("-p", "roles/" + role + "/templates")
        mkdir("-p", "roles/" + role + "/tasks")
        touch("roles/" + role + "/tasks/main.yml")
        mkdir("-p", "roles/" + role + "/handlers")

if __name__ == '__main__':
    arguments = docopt(__doc__, version='ansible-dirs 0.1')
    if arguments['playbook']:
        create_playbook(arguments['<name>'])
    elif arguments['role']:
        create_role(arguments['<name>'])

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
