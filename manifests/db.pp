# == Class: magnum::db
#
#  Configure the magnum database
#
# === Parameters
#
# [*database_connection*]
#   Url used to connect to database.
#   (Optional) Defaults to "mysql://magnum:secrete@localhost:3306/magnum".
#
# [*database_idle_timeout*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to $::os_service_default
#
# [*database_max_retries*]
#   Maximum number of database connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to $::os_service_default
#
# [*database_retry_interval*]
#   Interval between retries of opening a database connection.
#   (Optional) Defaults to $::os_service_default
#
# [*database_min_pool_size*]
#   Minimum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $::os_service_default
#
# [*database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $::os_service_default
#
# [*database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to $::os_service_default
#
class magnum::db (
  $database_connection     = 'mysql://magnum:secrete@localhost:3306/magnum',
  $database_idle_timeout   = $::os_service_default,
  $database_min_pool_size  = $::os_service_default,
  $database_max_pool_size  = $::os_service_default,
  $database_max_retries    = $::os_service_default,
  $database_retry_interval = $::os_service_default,
  $database_max_overflow   = $::os_service_default,
) {

  $database_connection_real = pick($::magnum::database_connection, $database_connection)
  $database_idle_timeout_real = pick($::magnum::database_idle_timeout, $database_idle_timeout)
  $database_min_pool_size_real = pick($::magnum::database_min_pool_size, $database_min_pool_size)
  $database_max_pool_size_real = pick($::magnum::database_max_pool_size, $database_max_pool_size)
  $database_max_retries_real = pick($::magnum::database_max_retries, $database_max_retries)
  $database_retry_interval_real = pick($::magnum::database_retry_interval, $database_retry_interval)
  $database_max_overflow_real = pick($::magnum::database_max_overflow, $database_max_overflow)

  validate_re($database_connection_real,
    '(mysql|postgresql):\/\/(\S+:\S+@\S+\/\S+)?')

  oslo::db { 'magnum_config':
    connection     => $database_connection_real,
    idle_timeout   => $database_idle_timeout_real,
    min_pool_size  => $database_min_pool_size_real,
    max_pool_size  => $database_max_pool_size_real,
    max_retries    => $database_max_retries_real,
    retry_interval => $database_retry_interval_real,
    max_overflow   => $database_max_overflow_real,
  }

}
