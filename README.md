A VVV 2.x based Wordpress project template that includes an optimal structure for fast creation of a new site, `composer.json`-enabled plugin workflow with ACF Pro and Timber plugins included, and a Timber based theme (default, but any other theme can be used as well).

The project boilerplate can be used for creation of multiple WP sites (projects) within one VVV VM. This does NOT mean it is targeted at WP multisites creation.

## Why use this boilerplate?

- It makes it easier to start new sites on the same VVV install;
- it makes plugin installation effortless with `composer.json` and includes a couple of plugin dependencies that are useful for common theme development;
- it structures the project conveniently so that all the stuff related to one project would end up in the same place;
- all the unrelated files get ignored by default ([you define what is whitelisted](https://salferrarello.com/wordpress-gitignore/)). So no logs or db files checked out accidentally;
- by default it allows using a boilerplate theme optimised for modern, highly automated, component-enabled, DRY development.

## Installation

The boilerplate uses [VVV2](https://varyingvagrantvagrants.org) for local installation. 

Default WP login and password are `admin` and `password`, and the MYSQL credentials are `wp`/`wp`.

### Prerequisites

 - This boilerplate assumes that you will store your project in a git repo of its own (it's perfectly possible to use non-git existing codebase with VVV 2.x, but maybe you don't need this boilerplate then);
 - it is advisable to use a `.test` local domain. [See why](https://varyingvagrantvagrants.org/docs/en-US/troubleshooting/dev-tld/);
 - it is a good idea to have your site folder located separately from the main VVV directory (with the `local_dir` key of project config in `vvv-custom.yml`).

### Installing VVV2

First you need to install VVV itself. Skip this if you already have VVV 2.x installed. This part is pretty standard and is the same that [the official installation procedure](https://varyingvagrantvagrants.org/docs/en-US/installation/).

1. clone or download [VVV2](http://github.com/Varying-Vagrant-Vagrants/VVV) (follow the instuctions in [their docs](https://varyingvagrantvagrants.org/docs/en-US/installation/));
2. create a copy of `vvv-config.yml` in the VVV2 directory naming it `vvv-custom.yml` (see the installation note 2).

### Adding a new site project using the boilerplate

1. Fork this repo or push it to a Git server of your choice. Copy the git URL (SSH);
2. add the site to `vvv-custom.yml`, replacing placeholders in `{}` accordingly:

    ```
    {your_project_name}: 
      repo: {git URL to YOUR repo}
      hosts:
        - {your_domain}.test 
      local_dir: {absolute path on your computer where the site folder will be. Can be outside of VVV2 folder}
      custom:
	      site_title: {Site title (optional, {your_project_name} by default)}
	      db_name: {local DB name (optional, {your_project_name} by default)}
	      acf_pro_key: {insert your ACF Pro key here (optional)}
	      install_boilerplate_theme: true
    ```
	
	For example, this is a valid config:

	```
	acme:
	  repo: git@github.com:githubuser/my-wp-site.git
	  hosts:
	    - acme-domain.test
	  local_dir: /Users/user/Sites/acme_site
	  custom:
	    site_title: My new WP project
	    db_name: acme_db
	    acf_pro_key: XXXX
	    install_boilerplate_theme: true
	```

3. do `vagrant reload --provision` now (and later if the procedure finishes with some problems);
4. (optionally) create an `.env` file in the `site` dir. Two constants can be added there right away (you can also use the file later for other environment-dependent values):
	1. If you own an ACF Pro license, you need to add the key here as the value for `ACF_PRO_KEY` constant to have the plugin automatically installed on `composer install` when not provisioning (in a form of `ACF_PRO_KEY=XXXX`). Note that this is in addition to the `acf_pro_key` key in `vvv-custom.yml`. If you don't own a Pro license — remove the lines 7-22 and 25 from `site/composer.json`;
	2. On staging/production you might want to add an `ENV` constant to this file equal to anything except for `dev`;
5. rename the theme folder to your name and update the last line in the root `.gitignore` file accordingly;
6. once provision is successful, remove `install_boilerplate_theme` key from the project config in `vvv-custom.yml` or set it to `false`. Otherwise you'll have all your themes removed and the boilerplate theme installed again;
6. (optionally) continue with the Timber-based theme installation by following the `README.md` in the `site/wp-content/themes/{your_theme}` folder.

### Installation notes

1. If you want to use your own boilerplate theme instead of the provided one right prior to VVV project creation, comment out the lines that start from `noroot wp theme install` in `provision/vvv-init.sh`;
2. you can remove/comment out the default sites from `vvv-config.yml` (`wordpress-develop` and `wordpress-default`) if you wish. You can also later add the sites from other Wordpress projects as well into the same VM by redoing the step 2.

### Usage notes

1. If you need to run a `composer install` during development, it may be a good idea to do it as `www-data` user to allow updating plugins from WP admin as well:

    ```
    sudo -u www-data /usr/local/bin/composer install
    ```

2. Update the last lines in the root `.gitignore` file once you have custom plugins that need to be tracked by your repo. 
