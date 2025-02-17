<?php
define('WORDPRESS_DB_DB_NAME', 'wordpress');
define('WORDPRESS_DB_USER', 'wordpress');
define('WORDPRESS_DB_DB_PASSWORD', 'wordpress');
define('WORDPRESS_DB_HOST', 'mariadb');  // Use the service name in docker-compose


$table_prefix = 'wp_';

define('WP_DEBUG', false);

if (!defined('ABSPATH')) {
    define('ABSPATH', dirname(__FILE__) . '/');
}
require_once ABSPATH . 'wp-settings.php';
