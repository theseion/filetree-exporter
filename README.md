Monticello to Filetree Exporter
===============================

This is a Pharo command line tool to help migrating existing monticello repositories to git using [filtree](https://github.com/dalehenrich/filetree).

This script does the following:
- exports all Monticello versions of a given repository in chronological order,
- allows you to map the Monticello user names to proper git authors.


## Example Usage

~~~
pharo filetree-exporter.image filetree-exporter --help
pharo filetree-exporter.image filetree-exporter users --from=$MC_REPO_URL > users.txt
~~~

Now you can edit the user mapping in `users.txt`, line by line with the following format:
~~~
MONTICELLO-USER NAME SURNAME <EMAIL>
~~~

After that you can start exporting the monticello repository

~~~
pharo filetree-exporter.image filetree-exporter export --from=$MC_REPO_URL --user-map=users.txt
~~~

