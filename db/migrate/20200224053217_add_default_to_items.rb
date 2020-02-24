class AddDefaultToItems < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :image, :string, :default => "https://i.pinimg.com/originals/97/1b/8d/971b8dbcde2119776efdd26f0bbd4f47.jpg"
  end
end
