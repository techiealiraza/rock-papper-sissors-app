class AddSelectionTriesToSelection < ActiveRecord::Migration[6.1]
  def change
    add_column :selections, :try_num, :integer
  end
end
