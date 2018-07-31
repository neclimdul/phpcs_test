#!/bin/sh -x

echo "Ensure clean vendor to show results."
rm -rf vendor
composer install

echo "Fails out of box."
php ./vendor/bin/phpcs src

echo "Fail with relative path."
php ./vendor/bin/phpcs --config-set installed_paths ./vendor/drupal/coder/coder_sniffer
php ./vendor/bin/phpcs src

echo "Works with absolute path but that is environment specific so fails in container."
php ./vendor/bin/phpcs --config-set installed_paths $(pwd)/vendor/drupal/coder/coder_sniffer
php ./vendor/bin/phpcs src
lando php ./vendor/bin/phpcs src

echo "Works with absolute path but that is environment specific so fails in locally."
php ./vendor/bin/phpcs --config-set installed_paths /app/vendor/drupal/coder/coder_sniffer
php ./vendor/bin/phpcs src
lando php ./vendor/bin/phpcs src

echo "Reinstalling vendor causing another fail."
rm -rf vendor
composer install
php ./vendor/bin/phpcs src

