SymfonyZero
================

# What is?
 
SymfonyZero is a free fully functional kickstarter edition. You can use it as a base for your Symfony web projects with a typical architecture. SymfonyZero includes the most common bundles pre configured and the usual sections of a website with responsive design. SymfonyZero helps you to build web projects more quickly, saving time in the early stages of the development. Also, you can enable or disable any feature easily, and also, SymfonyZero is fully configurable to adapt it to the needs of your project.

In this documentation you can learn about how to install, configure, what bundles and sections are available and how you can help to improve it. SymfonyZero is an alive project and we'll be adding new features and improvements, so stay tuned for new updates.

If you detect an error, you know how to improve it or you have an idea about this edition, please, fix it, do it or write us!

# Requirements

SymfonyZero uses the last LTS version: Symfony 2.8 (although you can change it easily), so you need to keep in your mind these requirements:

**Mandatory**
 ```
* PHP needs to be a minimum version of PHP 5.3.9 (recommended 5.5.9 or higher)
* JSON needs to be enabled
* ctype needs to be enabled
* Your php.ini needs to have the date.timezone setting
 ```
 
 **Optional**
  ```
*  You need to have the PHP-XML module installed
*  You need to have at least version 2.6.21 of libxml
*  You need to install elasticsearch (1.7.2 version recommended)
*  PHP tokenizer needs to be enabled
*  mbstring functions need to be enabled
*  iconv needs to be enabled
POSIX needs to be enabled (only on *nix)
*  Intl needs to be installed with ICU 4+
*  APC 3.0.17+ (or another opcode cache needs to be installed)
*  php.ini recommended settings
        - short_open_tag = Off
        - magic_quotes_gpc = Off
        - register_globals = Off
        - session.auto_start = Off
 ```
 
 If you change the Symfony version, these requirements could change. In this case you must visit the [oficial site](http://symfony.com/doc/current/reference/requirements.html) to check them.
 
 SymfonyZero provides integration with Memcache, so you need to install previously some dependencies:
 
 ```sh
 apt-get install memcached php5-memcache
 ```
 
 If you don't want to use memcache, you can disable the bundle before the setup process. To do this, remove in composer.json the line:
 
 ```sh
 "leaseweb/memcache-bundle": "^2.1",
 ```
 
 and in the file _app/AppKernel.php_ the line:
 
 ```sh
 new Lsw\MemcacheBundle\LswMemcacheBundle(),
 ```
 
 Also, to install the bundle to work with MailChimp you need to install curl (if you use our deploy script, curl and all dependencies will be installed automatically):
 
 ```sh
 apt-get install php5-curl
 ```
 
 By default, the bundle is disabled, so if you want to use it, you must add the bundle in _composer.json_ before the composer install command:
 
  ```sh
 "mlpz/mailchimp-bundle": "dev-master",
 ```
 
 And in the file _app/AppKernel.php_ uncomment the line:
 
  ```sh
 new MZ\MailChimpBundle\MZMailChimpBundle(),
 ```
 
 Also, to install the bundle to integrate with ElasticSearch, you need to follow several steps. First, we have to activate the bundle. Open _app/AppKernel.php_ file and uncomment the line:
 
  ```sh
 new FOS\ElasticaBundle\FOSElasticaBundle()
 ```
 Then, we have to activate the listener for indexing users. Open _app/config/services.yml_ file and uncomment the lines:
 
  ```sh
     symfonyzero.elastica_listener_users:
        class: AppBundle\Listener\UsersListener
        #Object_persister: entity indexed at elasticsearch.yml config file 
        arguments:
            - @fos_elastica.object_persister.symfonyzero.user
            - @fos_elastica.indexable
        calls:
            - [ setContainer, ['@service_container'] ]
        tags:
            - { name: doctrine.event_listener, event: postPersist }
            - { name: doctrine.event_listener, event: postUpdate }
            - { name: kernel.event_listener, event: kernel.terminate, method: onKernelTerminate }
 ```
 Finally, we have to include the elasticsearch config file. Open _app/config/config.yml_ file and uncomment the line:
 
  ```sh
            - { resource: elasticsearch.yml }
 ```
 
# Setup
 
  Install SymfonyZero as base of your projects is very easy. You have two options, one using the automatic script for the installation (if you choose this option, please jump to the next section), or following the step by step tutorial. If you prefer to install it manually to know all the process, please read the following instructions.
    
  First, you have to clone this repository in your web root directory:
 
 ```sh
$ git clone https://github.com/Emergya/SymfonyZero.git
```

To use Doctrine Data Fixtures you need PHP 5.6 or higher, so if you have previous version installed and you don't want to upgrade it, you have to remove this dependency in _composer.json_ deleting the line:

```json
"doctrine/doctrine-fixtures-bundle": "^2.3"
```

Then, you have to install vendors using Composer. If you don't have Composer installed, follow the instructions that you can find in [his web site](https://getcomposer.org/). Once you have Composer installed you'll can install vendors:

 ```sh
$ composer install
```

Make sure you set up right permission to run correctly the application. To do this, you can follow the instructions you can find in the [official book](http://symfony.com/doc/current/book/installation.html#book-installation-permissions).

By default, SymfonyZero uses MySQL database called _symfony_zero_. You need also an user with permissions in that database, if you didn't set previously, you can set now in _app/config/parameters.yml_ . Then you can run this command to create de database and his schema:

 ```sh
$ php bin/console doctrine:database:create
$ php bin/console doctrine:schema:create
```

If you change the model, remember you have to do this:

```sh
$ php bin/console doctrine:schema:update --force
```

To run the application you have to configure your web server correctly. You can see how to configure it in the [official guide](http://symfony.com/doc/current/cookbook/configuration/web_server_configuration.html). When you have your server running and configured, you can check the installation in your browser:
```
http://localhost:8000/config.php
```

Now you can build your own project using SymfonyZero by yourself. You have available different bundles and sections. To enable or disable these options, and to know how to configure all the possibilities of SymfonyZero, read next chapters about the current features available and how you can configure them.
 
# Deploy

You can avoid all the setup process using the _deploy script_. You can install SymfonyZero in a clean environment (with apt-get package manager available) and all the configuration and the actions will be done automatically.

You only need the _deploy_ folder you can find in the root of this repository. Then run:

```sh
$ sudo ./setup.sh
```

And you will have SymfonyZero running in your system (You can check it in _http://symfonyzero_). If you want to change anything of the process, you can edit _setup.sh_ file.

For example, by default SymfonyZero-API is installed in _/var/www/SymfonyZero-API/_ directory, but you can modify it changing in _setup.sh_ var _SYMFONYPATH_, and
 of course, changing that path in the virtual host (_symfonyzeroapi.conf_).

By default, script will install PHP 7 if doesn't found any PHP version installed or find a previous version of PHP 5.6. This deploy is prepared to install a previous version, so if you prefer to install PHP 5.6 you can edit _setup.sh_ and
follow the instructions you will find in it, you only have to comment one line and uncomment another one.

# How to update

If you update your repository with a new version of SymfonyZero of with your new changes, you don't need to do again all the commands includes in the previous section. To do it quicker we provides a console command which execute the needed commands for you.

First you have to install new composer dependencies:

```sh
$ composer install
```

Then, to run the update command:

```sh
$ php bin/console zero:deploy
```

If you want to edit the command to suit your needs, you can find it in _src/AppBundle/Command/DeployCommand.php_.


# Features
 
 SymfonyZero helps you to develop build your web applications quickly. SymfonyZero is made up of several bundles (Symfony Standard Edition bundles and Third party bundles) and usual features and sections which appears in a wide range of websites. In this section you can read what is included in each of these parts.
 
**Third Party Bundles**

SymfonyZero has available a pre-configured third party bundles to give a solution for the most common needs of the web projects. In this list you can discover what bundles are installed and the link to access to their official repositories.

*  [FOSUserBundle](https://github.com/FriendsOfSymfony/FOSUserBundle) - FOSUserBundle provides a flexible framework for user management that aims to handle common tasks such as user registration and password retrieval.
*  [EasyAdminBundle](https://github.com/javiereguiluz/EasyAdminBundle) - EasyAdminBundle lets you create administration backends for Symfony applications with unprecedented simplicity.
*  [KnpPaginatorBundle](https://github.com/KnpLabs/KnpPaginatorBundle) - KnpPaginatorBundle is a friendly Symfony paginator to paginate everything.
*  [WhiteOctoberBreadcrumbsBundle](https://github.com/whiteoctober/BreadcrumbsBundle) - WhiteOctoberBreadcrumbsBundle provides a easy way to create bread crumbs.
*  [StfalconTinymceBundle](https://github.com/stfalcon/TinymceBundle) - StfalconTinymceBundle makes it very easy to add the TinyMCE WYSIWYG editor to your Symfony project.
*  [RaulFraileLadybugBundle](https://github.com/raulfraile/LadybugBundle) - RaulFraileLadybugBundle provides an easy and extensible var_dump/print_r replacement for Symfony projects, both in controllers or Twig templates.
*  [XsolveCookieAcknowledgementBundle](https://github.com/xsolve-pl/xsolve-cookie-acknowledgement-bundle) - XsolveCookieAcknowledgementBundle provides information about an cookies usage, which is forced by European Union by so-called EU cookie law.
*  [SonataSeoBundle](https://github.com/sonata-project/SonataSeoBundle) - SonataSeoBundle provides a Site and Page management through container and block services.
*  [KnpMenuBundle](https://github.com/KnpLabs/KnpMenuBundle) - KnpMenuBundle integrates the KnpMenu PHP library with Symfony. This means easy-to-implement and feature-rich menus in Symfony applications.
*  [LswMemcacheBundle](https://github.com/LeaseWeb/LswMemcacheBundle) - LswMemcacheBundle provides Memcache integration into Symfony and Doctrine for session storage and caching.
*  [SonataIntlBundle](https://github.com/sonata-project/SonataIntlBundle) - SonataIntlBundle provides text and date formatting depends on locale.
*  [MZMailChimpBundle](https://github.com/miguel250/MZMailChimpBundle) - MZMailChimpBundle is a bundle which integrates MailChimp API with Symfony Apps easily.
*  [HWIOAuthBundle](https://github.com/hwi/HWIOAuthBundle) - HWIOAuthBundle adds support for authenticating users via OAuth1.0a or OAuth2 in Symfony2 with more of 40 different providers like Facebook, Twitter, Google...
*  [AsseticBundle](https://github.com/symfony/assetic-bundle) - AsseticBundle provides integration of the Assetic library into the Symfony2 framework.
*  [VichUploaderBundle](https://github.com/dustin10/VichUploaderBundle) - VichUploaderBundle is a bundle that attempts to ease file uploads that are attached to ORM entities, MongoDB ODM documents, PHPCR ODM documents or Propel models. 

**Common Sections and Functionality**
 
 * Responsive design using Bootstrap
 * Landing page
 * Carousel that you can manage it from admin panel
 * Private section to manage entities
 * Contact form with email service pre-configured
 * Login, register and password change
 * About me section
 * Cookies law bar
 * Terms & Conditions section
 * Demos of different features
 * Header section with company's logo and dynamic menu
 * Footer section with common links
 * data fixtures with example users

**Symfony Standard Edition**
 
Extracted of the [official repository of Symfony](https://github.com/symfony/symfony-standard), here we have the pre-configured bundles we have available because they are in the Symfony Standard Edition:

*  FrameworkBundle - The core Symfony framework bundle
*  SensioFrameworkExtraBundle - Adds several enhancements, including template and routing annotation capability
*  DoctrineBundle - Adds support for the Doctrine ORM
*  TwigBundle - Adds support for the Twig templating engine
*  SecurityBundle - Adds security by integrating Symfony's security component
*  SwiftmailerBundle - Adds support for Swiftmailer, a library for sending emails
*  MonologBundle - Adds support for Monolog, a logging library
*  WebProfilerBundle (in dev/test env) - Adds profiling functionality and the web debug toolbar
*  SensioDistributionBundle (in dev/test env) - Adds functionality for configuring and working with Symfony distributions
*  SensioGeneratorBundle (in dev/test env) - Adds code generation capabilities
*  DebugBundle (in dev/test env) - Adds Debug and VarDumper component integration
 
# Config
 
 In this section you will learn how to configure all the possibilities of SymfonyZero. You can modify a lot of features, including versions.

If you want to change the *Symfony version* you must edit the file _composer.json_, specifically the line:

```
"symfony/symfony": "2.8.*",
```

Although we use Symfony 2.8, SymfonyZero has the new directory structure (Symfony 3.0 or higher) but if you want, you can [override this structure](http://symfony.com/doc/current/configuration/override_dir_structure.html).

Changing this for the version you prefer, when you running _composer install_, you will get that version of Symfony. Remember that some bundles could work differently for other versions of Symfony. Also, changing that file you can change the version of the bundle you prefer, for example, if you want to change the version of KnpPaginatorBundle, you have to change next line:

```
"knplabs/knp-paginator-bundle": "^2.5",
```

By the fault all the bundles are enabled, you can *disable any bundle* if you will not use. For this purpose, you must modify the _AppKernel.php_ file. You can find it in _app/_. In that file you will see all the bundles enabled for all environments. If you want to disable one bundle, just comment it. For example, to disable SonataSeoBundle:

```php
//new Sonata\SeoBundle\SonataSeoBundle(),
```

Also, if you will never use this bundle, you can remove if from your _composer.json_ file.

Another modification you can do is the *database configuration*. By default SymfonyZero is prepared to use a database called _symfony_zero_ with an user and password _symfonyApi_ you set in the firsts steps, but you can change it. To do this you have to edit the _parameters.yml_ file you can find in _app/config/_ route. Once time you create your new database and the user, you can edit this file. The parameters you must change are:

```yml
    database_host: 127.0.0.1
    database_port: null
    database_name: symfony_zero
    database_user: userExample
    database_password: passwordExample
```

SymfonyZero is prepared to *send emails* with a email service provider. You can modify this to use your favourite system to send emails, for example Gmail, Mandrill, Amazon's SES... To change this you have to edit the _parameters.yml_ file you can find in _app/config/_ route.

```yml
    mailer_transport: smtp
    mailer_host: smtp.mandrillapp.com
    mailer_user: MAIL_USER
    mailer_password: MAIL_PASSWORD
```

To send a email SymfonyZero provides a service which uses Swiftmailer and you can call from anywhere of your application:

```php
$emailService = $this->get('symfonyzero.email');
$emailService->sendEmail($email['subject'], $email['from'], $email['to'], $email['template'], $email);
```

This service now is using a template placed in _src/AppBundle/Resources/views/Templates_, but you are free to create and use all the templates you need. Also the last parameter is an array with parameters with which you can work in the twig template.

All the functions are used like an examples in DefaultController only with the goal you know how can you use them. In a real application you must remove them and use only the functions and views you need. Also you can find a User entity based in FOSUserBundle users, a contact form, menu builder and a private section in _/admin/_ path only reachable for admin users. Feel free to use, modify or remove all the features to speed up the develop of your own application.

Of course, *each bundle* has a lot of different configuration you can change to adjust them to your needs. By default, SymfonyZero has the usual configuration for each bundle, but of course you can modify them. For this, you have to do these editions in _config.yml_ file which you can find in _app/config/_ route. For example, EasyAdminBundle is prepared for the User Entity, but if you wan to add a new one, you only have to modify this:

```yml
easy_admin:
    entities:
        - AppBundle\Entity\User
        - AppBundle\Entity\YourNewEntity
```

If you have activated ElasticaBundle, you'll have to configure Elastic Search. Open the _app/config/parameters.yml_ file and include this parameters:
```yml
elastic_host: 
elastic_port: 
```

SymfonyZero provides an example of data fixtures with some users. You can use it to test the application with these users (with different roles) or to generate your own data fixture using these like a base of your owns.

You can find the fixtures already created in _src/AppBundle/DataFixtures/ORM/LoadUserData.php_ and you can generate these dates using next console command:

```sh
$ php bin/console doctrine:fixtures:load
```

Once you run this command, you can log in the application using one of these users you can find in the _LoadUserData.php_ class. For security reasons remember delete these users before your application will be in a production environment.

In the previous section, you can find all the links for the official documentation for each bundle. Check it if you want to know all the possibilities to customize your application.

By default, SymfonyZero provides a base repository and base manager which the most used functions like create an entity, find by id, update an entity... And a repository and manager classes like an examples (for User and Comment entities). It's a good practice if you follow this structure when you create new entities. You can configure these files in src/AppBundle/Resources/config.

The main idea is to store all the queries about a specific entity in the _repository_ and the _manager_ is the service in which you will delegate the responsibility of store usual methods you will need to use in different points of the applications.

With little knowledge of Symfony you will be able to use all the SymfonyZero possibilities and you will increase improve the development of your own applications.
 
# Improvements and contact
 
This is an open source project to contribute with the community and we are delighted to be helped by you, so if you have an idea to improve SymfonyZero or you find a bug, please create an issue and explain us clearly and with details your idea or the bug you have found.

In case you are able to patch any bug or add a new feature, don't hesitate and make a pull request. First, fork the repository and clone it locally. Then, create a branch for your edits. When you end your contribution, open a pull request and we'll discuss your changes.

If you have any doubt around how to contribute using GitHub, you can read the official guide [to contribute to open source project](https://guides.github.com/activities/contributing-to-open-source/).

Also, you can contact with developers in [symfony@emergya.com](symfony@emergya.com). We'll be glad to talk with you :)
