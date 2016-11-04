class AddSuperpowersField < ActiveRecord::Migration
  def change
    add_column :superheros, :superpowers, :text
  end
end
