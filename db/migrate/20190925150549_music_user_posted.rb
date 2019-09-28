class MusicUserPosted < ActiveRecord::Migration[5.2]
  def change
    create_table :postmusics do |t|
      t.references :user
      t.string :img
      t.string :artistName
      t.string :collectionName
      t.string :trackName
      t.string :preView
      t.string :comments
      t.timestamps null: false
    end
  end
end
