class AddCreatorAndStudio < ActiveRecord::Migration
  def change
    add_column :superheros, :creator, :text
    add_column :superheros, :studio, :text
  end
end
