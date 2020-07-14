class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.string :access_code
      t.string :image
      t.string :client_email
      t.string :client_name
      t.datetime :start_time
      t.datetime :end_time
      t.references :server, foreign_key: true

      t.timestamps
    end
  end
end
