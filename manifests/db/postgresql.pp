# == Class: magnum::db::postgresql
#
# Class that configures postgresql for magnum
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'magnum'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'magnum'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class magnum::db::postgresql(
  $password,
  $dbname     = 'magnum',
  $user       = 'magnum',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  Class['magnum::db::postgresql'] -> Service<| title == 'magnum' |>

  ::openstacklib::db::postgresql { 'magnum':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  ::Openstacklib::Db::Postgresql['magnum'] ~> Exec<| title == 'magnum-manage db_sync' |>

}
