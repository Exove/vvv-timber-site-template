The files in this directory should be copied to `.git/hooks` in order for git hooks to work.

After copying the `post-merge` file, change `php-fpm` if needed to the appropriate user that runs php process on your machine.

You can duplicate the `post-merge` file as `post-checkout` in the same dir to have the hook applied not only on `git pull` but also on `git checkout`.
