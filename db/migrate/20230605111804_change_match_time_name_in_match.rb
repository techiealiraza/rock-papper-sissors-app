class ChangeMatchTimeNameInMatch < ActiveRecord::Migration[6.1]
  def change
    rename_column :matches, :match_time, :time
  end
end
