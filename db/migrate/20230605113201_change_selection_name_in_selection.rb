class ChangeSelectionNameInSelection < ActiveRecord::Migration[6.1]
  def change
    rename_column :selections, :selection, :choice
  end
end
