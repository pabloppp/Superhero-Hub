class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.string :ip
      t.integer :value
      t.references :superhero, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
