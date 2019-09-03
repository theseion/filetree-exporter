Monticello to Filetree Exporter
===============================

This is a [Pharo](https://github.com/pharo-project/pharo) command line tool to help migrating existing monticello repositories to git using [filetree](https://github.com/dalehenrich/filetree).

This script does the following:
- exports all Monticello versions of a given repository in chronological order,
- allows you to map the Monticello user names to proper git authors.

## Migration to tonel
Pharo has introduced a new format called [tonel](https://github.com/pharo-vcs/tonel). To use tonel you can use the filetree exporter to first export your project into filetree format and then use Iceberg (the Pharo Git tool) to convert your repository to tonel.

## Example Usage

```bash
MC_REPO_URL="http://smalltalkhub.com/mc/UserName/Project/main"
pharo exporter.image metacello install "github://theseion/filetree-exporter" BaselineOfFileTreeExporter
pharo exporter.image filetree-exporter --help
pharo exporter.image filetree-exporter users --from="$MC_REPO_URL" > users.txt
```

Now you can edit the user mapping in `users.txt`, line by line with the following format:
~~~
...
MONTICELLO-USER NAME SURNAME <EMAIL>
...
~~~

After that you can start exporting the monticello repository

```bash
pharo exporter.image filetree-exporter export \
   --from="$MC_REPO_URL" \
   --to="~/my-git-repos/the-project"
   --user-map=users.txt
   --package-filter="MyPackage.*"
   --skip=100
```

Now you have a complete copy of the contents of `$MC_REPO_URL` in the local git repository under `~/my-git-repos/the-project`.

## Push the Exported Repository
Execute the following bash commands to push the expoter Monticello versions to an empty github repository:
```bash
cd ~/my-git-repos/the-project
git remote add origin git@github.com:$GITHUB_USER/$GITHUB_REPO.git
git push --set-upstream origin master
```

If you created the github repository already with a `README.md` file, rebase your exported version on top.
Instead of the direct `git push` command execute the following statements:
```bash
cd ~/my-git-repos/the-project
git remote add origin git@github.com:$GITHUB_USER/$GITHUB_REPO.git
git fetch --all
# replay the versions of the exported repository on top of the existing remote versions
git rebase origin/master
git push --set-upstream origin master
```
