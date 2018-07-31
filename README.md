# Description

A sample repo to demonstrate some of the frustrating behaviors of PHPCS when using outside rules.

To test simply run test.sh from the command line. It does rely on landodev to
facilitate demonstating how the configuration does not translate well to mixed
environments like containers where the absolute paths for not match.

# Sample Output

```
+ echo Ensure clean vendor to show results.
Ensure clean vendor to show results.
+ rm -rf vendor
+ composer install
Loading composer repositories with package information
Installing dependencies (including require-dev) from lock file
Package operations: 4 installs, 0 updates, 0 removals
  - Installing symfony/polyfill-ctype (v1.8.0): Loading from cache
  - Installing symfony/yaml (v4.1.2): Loading from cache
  - Installing squizlabs/php_codesniffer (2.9.1): Loading from cache
  - Installing drupal/coder (8.2.12): Cloning 984c54a7b1 from cache
symfony/yaml suggests installing symfony/console (For validating YAML files using the lint command)
Generating autoload files
+ echo Fails out of box.
Fails out of box.
+ php ./vendor/bin/phpcs src
PHP Fatal error:  Uncaught PHP_CodeSniffer_Exception: Referenced sniff "Drupal.Array.Array" does not exist in /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php:1167
Stack trace:
#0 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php(780): PHP_CodeSniffer->_expandRulesetReference(Object(SimpleXMLElement), '/var/www/html/p...', 0)
#1 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php(578): PHP_CodeSniffer->processRuleset('/var/www/html/p...')
#2 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php(956): PHP_CodeSniffer->initStandard(Array, Array, Array)
#3 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php(113): PHP_CodeSniffer_CLI->process()
#4 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/scripts/phpcs(25): PHP_CodeSniffer_CLI->runphpcs()
#5 {main}
  thrown in /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php on line 1167
+ echo Fail with relative path.
Fail with relative path.
+ php ./vendor/bin/phpcs --config-set installed_paths ./vendor/drupal/coder/coder_sniffer
Config value "installed_paths" added successfully
+ php ./vendor/bin/phpcs src
PHP Fatal error:  Uncaught PHP_CodeSniffer_Exception: Referenced sniff "Drupal.Array.Array" does not exist in /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php:1167
Stack trace:
#0 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php(780): PHP_CodeSniffer->_expandRulesetReference(Object(SimpleXMLElement), '/var/www/html/p...', 0)
#1 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php(578): PHP_CodeSniffer->processRuleset('/var/www/html/p...')
#2 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php(956): PHP_CodeSniffer->initStandard(Array, Array, Array)
#3 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php(113): PHP_CodeSniffer_CLI->process()
#4 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/scripts/phpcs(25): PHP_CodeSniffer_CLI->runphpcs()
#5 {main}
  thrown in /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php on line 1167
+ echo Works with absolute path but that is environment specific so fails in container.
Works with absolute path but that is environment specific so fails in container.
+ pwd
+ php ./vendor/bin/phpcs --config-set installed_paths /var/www/html/phpcs_test/vendor/drupal/coder/coder_sniffer
Config value "installed_paths" updated successfully; old value was "./vendor/drupal/coder/coder_sniffer"
+ php ./vendor/bin/phpcs src

FILE: /var/www/html/phpcs_test/src/Test.php
----------------------------------------------------------------------
FOUND 1 ERROR AFFECTING 1 LINE
----------------------------------------------------------------------
 8 | ERROR | [x] Perl-style comments are not allowed; use "//
   |       |     Comment" instead
----------------------------------------------------------------------
PHPCBF CAN FIX THE 1 MARKED SNIFF VIOLATIONS AUTOMATICALLY
----------------------------------------------------------------------

Time: 29ms; Memory: 6Mb

+ lando php ./vendor/bin/phpcs src
PHP Fatal error:  Uncaught PHP_CodeSniffer_Exception: Referenced sniff "Drupal.Array.Array" does not exist in /app/vendor/squizlabs/php_codesniffer/CodeSniffer.php:1167
Stack trace:
#0 /app/vendor/squizlabs/php_codesniffer/CodeSniffer.php(780): PHP_CodeSniffer->_expandRulesetReference(Object(SimpleXMLElement), '/app', 0)
#1 /app/vendor/squizlabs/php_codesniffer/CodeSniffer.php(578): PHP_CodeSniffer->processRuleset('/app/phpcs.xml')
#2 /app/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php(956): PHP_CodeSniffer->initStandard(Array, Array, Array)
#3 /app/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php(113): PHP_CodeSniffer_CLI->process()
#4 /app/vendor/squizlabs/php_codesniffer/scripts/phpcs(25): PHP_CodeSniffer_CLI->runphpcs()
#5 {main}
  thrown in /app/vendor/squizlabs/php_codesniffer/CodeSniffer.php on line 1167

Fatal error: Uncaught PHP_CodeSniffer_Exception: Referenced sniff "Drupal.Array.Array" does not exist in /app/vendor/squizlabs/php_codesniffer/CodeSniffer.php on line 1167

PHP_CodeSniffer_Exception: Referenced sniff "Drupal.Array.Array" does not exist in /app/vendor/squizlabs/php_codesniffer/CodeSniffer.php on line 1167

Call Stack:
    0.0001     352288   1. {main}() /app/vendor/squizlabs/php_codesniffer/scripts/phpcs:0
    0.0065    1520144   2. PHP_CodeSniffer_CLI->runphpcs() /app/vendor/squizlabs/php_codesniffer/scripts/phpcs:25
    0.0069    1564488   3. PHP_CodeSniffer_CLI->process() /app/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php:113
    0.0071    1569488   4. PHP_CodeSniffer->initStandard() /app/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php:956
    0.0071    1569504   5. PHP_CodeSniffer->processRuleset() /app/vendor/squizlabs/php_codesniffer/CodeSniffer.php:578
    0.0074    1570800   6. PHP_CodeSniffer->_expandRulesetReference() /app/vendor/squizlabs/php_codesniffer/CodeSniffer.php:780

+ echo Works with absolute path but that is environment specific so fails in locally.
Works with absolute path but that is environment specific so fails in locally.
+ php ./vendor/bin/phpcs --config-set installed_paths /app/vendor/drupal/coder/coder_sniffer
Config value "installed_paths" updated successfully; old value was "/var/www/html/phpcs_test/vendor/drupal/coder/coder_sniffer"
+ php ./vendor/bin/phpcs src
PHP Fatal error:  Uncaught PHP_CodeSniffer_Exception: Referenced sniff "Drupal.Array.Array" does not exist in /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php:1167
Stack trace:
#0 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php(780): PHP_CodeSniffer->_expandRulesetReference(Object(SimpleXMLElement), '/var/www/html/p...', 0)
#1 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php(578): PHP_CodeSniffer->processRuleset('/var/www/html/p...')
#2 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php(956): PHP_CodeSniffer->initStandard(Array, Array, Array)
#3 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php(113): PHP_CodeSniffer_CLI->process()
#4 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/scripts/phpcs(25): PHP_CodeSniffer_CLI->runphpcs()
#5 {main}
  thrown in /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php on line 1167
+ lando php ./vendor/bin/phpcs src

FILE: /app/src/Test.php
----------------------------------------------------------------------
FOUND 1 ERROR AFFECTING 1 LINE
----------------------------------------------------------------------
 8 | ERROR | [x] Perl-style comments are not allowed; use "//
   |       |     Comment" instead
----------------------------------------------------------------------
PHPCBF CAN FIX THE 1 MARKED SNIFF VIOLATIONS AUTOMATICALLY
----------------------------------------------------------------------

Time: 32ms; Memory: 6Mb

+ echo Reinstalling vendor causing another fail.
Reinstalling vendor causing another fail.
+ rm -rf vendor
+ composer install
Loading composer repositories with package information
Installing dependencies (including require-dev) from lock file
Package operations: 4 installs, 0 updates, 0 removals
  - Installing symfony/polyfill-ctype (v1.8.0): Loading from cache
  - Installing symfony/yaml (v4.1.2): Loading from cache
  - Installing squizlabs/php_codesniffer (2.9.1): Loading from cache
  - Installing drupal/coder (8.2.12): Cloning 984c54a7b1 from cache
symfony/yaml suggests installing symfony/console (For validating YAML files using the lint command)
Generating autoload files
+ php ./vendor/bin/phpcs src
PHP Fatal error:  Uncaught PHP_CodeSniffer_Exception: Referenced sniff "Drupal.Array.Array" does not exist in /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php:1167
Stack trace:
#0 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php(780): PHP_CodeSniffer->_expandRulesetReference(Object(SimpleXMLElement), '/var/www/html/p...', 0)
#1 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php(578): PHP_CodeSniffer->processRuleset('/var/www/html/p...')
#2 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php(956): PHP_CodeSniffer->initStandard(Array, Array, Array)
#3 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer/CLI.php(113): PHP_CodeSniffer_CLI->process()
#4 /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/scripts/phpcs(25): PHP_CodeSniffer_CLI->runphpcs()
#5 {main}
  thrown in /var/www/html/phpcs_test/vendor/squizlabs/php_codesniffer/CodeSniffer.php on line 1167
```
