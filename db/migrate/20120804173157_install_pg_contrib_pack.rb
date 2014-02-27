class InstallPgContribPack < ActiveRecord::Migration
  def self.up
    execute "CREATE EXTENSION pg_trgm;"
    execute "CREATE EXTENSION fuzzystrmatch;"
  end

  def self.down
    execute "DROP EXTENSION pg_trgm;"
    execute "DROP EXTENSION fuzzystrmatch;"
  end
end
