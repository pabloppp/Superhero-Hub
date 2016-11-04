class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.string :name
      t.text :description
      t.text :image_url
      t.text :superpowers
      t.text :creator
      t.text :studio
      t.references :superhero, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
