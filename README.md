A VVV 2.x based Wordpress project template that includes an optimal structure for fast creation of a new site, `composer.json` with ACF Pro and Timber plugins included, and a Timber based theme (default, but optional).

## Installation

The boilerplate uses [VVV2](https://varyingvagrantvagrants.org) for local installation. 

Default WP login and password are `admin` and `password`, and the MYSQL credentials are `root`/`root`.

### Installing VVV2

1. download [VVV2](http://github.com/Varying-Vagrant-Vagrants/VVV) (follow the instuctions in [their docs](https://varyingvagrantvagrants.org/docs/en-US/installation/));
2. create a copy of `vvv-config.yml` in the VVV2 directory naming it `vvv-custom.yml`. You can remove/comment out the default sites there (`wordpress-develop` and `wordpress-default`) if you wish. You can also later add the sites from other Wordpress projects as well into the same VM by doing similar steps;
3. add the site to `vvv-custom.yml` with these lines:

    ```
    sitename: 
      repo: {git path to the repo (SSH)}
      hosts:
        - sitename.test 
      local_dir: {absolute path on your computer where the site folder will be. Can be outside of VVV2 folder}
    ```

4. do `vagrant reload --provision` now (and later if the procedure finishes with some problems);
5. in the project folder, go to `public_html` and delete the `wp-content` folder;
6. inside the VM, make a symlink from `site/wp-content` to `public_html/wp-content`:

    ```
    ln -s /srv/www/sitename/site/wp-content /srv/www/sitename/public_html/wp-content
    ```

7. (optionally) create an `.env` file in the `site` dir. Two constants can be added there right away, and you can also use it later for other environment-dependent values:
	1. If you have an ACF Pro license, you can add the key here as the value for `ACF_PRO_KEY` constant to have the plugin automatically installed on `composer install` (in the form of `ACF_PRO_KEY=XXXX`);
	2. On staging/production you might want to add an `ENV` constant to this file equal to anything except for `dev`;
8. inside the VM, do `composer install` (see the installation notes 1 and 2);
9. (optionally) continue with the Timber-based theme installation by following the `README.md` in the `site/wp-content/themes/themename` folder.

### Installation notes

1. it may be a good idea to run `composer install` as `www-data` user to allow updating plugins from WP admin as well:

    ```
    sudo -u www-data /usr/local/bin/composer install
    ```

2. to allow the use of cache by composer in VM, create the dir `/home/vagrant/.composer` inside the VM and set its owner to `www-data`:

    ```
      sudo chown -R www-data:www-data .composer
    ```

3. if you've got problem with Timber plugin activation (blank screen and Timber related error), do the following inside the VM in the WP root. This basically switches to another theme temporarily, activates all the plugins and switches back to the project theme:

    ```
    wp theme install twentyseventeen --activate
    wp plugin activate --all
    wp theme activate themename
    ```
