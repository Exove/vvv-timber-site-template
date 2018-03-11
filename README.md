A VVV 2.x based Wordpress project template that includes an optimal structure for fast creation of a new site, `composer.json` with ACF Pro and Timber plugins included, and a Timber based theme (default, but any other theme can be used as well).

The project boilerplate can be used for creation of multiple WP sites within one VVV VM. 

## Why use this boilerplate?

- It makes it easier to start new sites on the same VVV install;
- it makes `composer.json` plugin installation effortless and includes a couple of plugin dependencies that are useful for common theme development;
- it structures the project conveniently so that all the stuff related to one project would end up in the same place;
- all the unrelated files get ignored by default ([you define what is whitelisted](https://salferrarello.com/wordpress-gitignore/)). So no logs or db files checked out accidentally;
- by default it allows using a boilerplate theme optimised for modern, highly automated, component-enabled, DRY development.

## Installation

The boilerplate uses [VVV2](https://varyingvagrantvagrants.org) for local installation. 

Default WP login and password are `admin` and `password`, and the MYSQL credentials are `wp`/`wp`.

### Prerequisites

 - This boilerplate assumes that you will store your project in a git repo of its own. (It's perfectly possible to use non-git existing codebase with VVV 2.x, but then maybe you don't need this boilerplate.)

### Installing VVV2

First you need to install VVV itself. Skip this if you already have VVV 2.x installed. This part is pretty standard and is the same that [the official installation procedure](https://varyingvagrantvagrants.org/docs/en-US/installation/).

1. clone or download [VVV2](http://github.com/Varying-Vagrant-Vagrants/VVV) (follow the instuctions in [their docs](https://varyingvagrantvagrants.org/docs/en-US/installation/));
2. create a copy of `vvv-config.yml` in the VVV2 directory naming it `vvv-custom.yml` (see the installation note 2).

### Adding a new site project using the boilerplate

1. Fork this repo or obtain it in some other manner;
2. Go through `provision/vvv-nginx.conf`, `provision/vvv-init.sh`, replacing `sitename` with your project/local domain name. The local domain [will be](https://varyingvagrantvagrants.org/docs/en-US/troubleshooting/dev-tld/) `{sitename}.test` (see the installation note 1);
3. Push the changes to a dedicated git repo of your site and copy the git URL;
6. add the site to `vvv-custom.yml` with these lines, replacing placeholders in `{}` accordingly:

    ```
    {sitename}: 
      repo: {git URL to YOUR repo (SSH)}
      hosts:
        - {sitename}.test 
      local_dir: {absolute path on your computer where the site folder will be. Can be outside of VVV2 folder}
    ```

7. (optionally) create an `.env` file in the `site` dir. Two constants can be added there right away, and you can also use the file later for other environment-dependent values:
	1. If you have an ACF Pro license, you can add the key here as the value for `ACF_PRO_KEY` constant to have the plugin automatically installed on `composer install` (in a form of `ACF_PRO_KEY=XXXX`);
	2. On staging/production you might want to add an `ENV` constant to this file equal to anything except for `dev`;
4. do `vagrant reload --provision` now (and later if the procedure finishes with some problems);
9. (optionally) continue with the Timber-based theme installation by following the `README.md` in the `site/wp-content/themes/timber-boilerplate` folder.

### Installation notes

1. If you want to use your own theme instead of the provided one, comment out the lines beginning from `noroot wp theme install` in `provision/vvv-init.sh`;
2. You can remove/comment out the default sites from `vvv-config.yml` (`wordpress-develop` and `wordpress-default`) if you wish. You can also later add the sites from other Wordpress projects as well into the same VM by redoing the step 6.

### Usage notes

1. If you need to run a `composer install` during development, it may be a good idea to do it as `www-data` user to allow updating plugins from WP admin as well:

    ```
    sudo -u www-data /usr/local/bin/composer install
    ```

2. to allow cache usage by composer in VM, check if the dir `/home/vagrant/.composer` exists inside the VM and if its owner set to `www-data`:

    ```
      sudo chown -R www-data:www-data .composer
    ```

