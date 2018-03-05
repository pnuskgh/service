<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wpuser');

/** MySQL database password */
define('DB_PASSWORD', 'myService1234');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'y[KR4NtPD?iQK4_-V?J$}t7)m]4h,1$7 h(<6}}V7GSRtDuElZrYbg[N;gpirp4A');
define('SECURE_AUTH_KEY',  '[&vU)l<17ne>lNJF{r|*%UZqKNxn.z^B}(W5gnPhIGtCJ#ns=0$TuW2eB7N9 b:W');
define('LOGGED_IN_KEY',    'l]ygtdy9Syk =-nNQE=K$77x{ 5Y-*pC4nloo]%=Uopn$<93mY/N_q@6HrR988Nj');
define('NONCE_KEY',        '1iG@Yxd$0v[kRevuT[HbXu)wR=a}<$-.J?G,mB)K<lBP|e)k.V)Io_~MJw|Gf=Rd');
define('AUTH_SALT',        '=}%kKz-~_T62KB:4F_lXhWbRo#MAl3}B:PfcLZ;uKUy1|`%y|nX#y)=Q|~zWA2E}');
define('SECURE_AUTH_SALT', '1}2KAcd-JwYNpDXep[+>4//eIJfc-=7!>uOXuri/I?eSTFBuKLVX%PWR+2ZNZ.@S');
define('LOGGED_IN_SALT',   'eMCiuH,u`cex`XyVHUotxDVVF-| E#,fOB:)(<fodaWg|.{27ZsXCNj$jTk?FK_$');
define('NONCE_SALT',       ']<om7QI8$Y+o@}-96<*SQ#!s;8y ?cb^[MAWWW&xgd_NPuAsht/zx]`<+KEs>{Z ');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

