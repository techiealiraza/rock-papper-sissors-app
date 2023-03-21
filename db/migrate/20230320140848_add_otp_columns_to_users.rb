class AddOtpColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :otp_secret_key, :string
    add_column :users, :otp_expiry_time, :datetime
  end
end
