class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :img #プロフがぞう
      t.references :music
      t.timestamps null: false
    end
  end
end
