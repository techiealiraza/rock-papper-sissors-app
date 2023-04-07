class AddRoundToMatches < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :round, :integer, default: 0
  end
end
