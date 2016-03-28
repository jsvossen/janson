class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.datetime :birthday
      t.string :location
      t.text :about
      t.references :user, index: true, foreign_key: true, unique: true

      t.timestamps null: false
    end
  end
end
