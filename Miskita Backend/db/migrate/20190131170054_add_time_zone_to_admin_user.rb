class AddTimeZoneToAdminUser < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_users, :time_zone, :string
  end
end
