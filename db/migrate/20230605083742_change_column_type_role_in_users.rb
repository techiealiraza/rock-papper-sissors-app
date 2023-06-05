class ChangeColumnTypeRoleInUsers < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      ALTER TABLE users
      ALTER COLUMN role
      SET DATA TYPE integer
      USING (CASE WHEN role ~ E'^\\\\d+$' THEN role::integer ELSE 0 END);
    SQL
  end
end
