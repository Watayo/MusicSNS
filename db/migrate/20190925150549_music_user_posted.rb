class MusicUserPosted < ActiveRecord::Migration[5.2]
  def change
    create_table :musics do |t|
      t.references :user
      t.string :name
      t.string :comments
      t.timestamps null: false
    end
  end
end
