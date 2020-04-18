class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :category
      t.string :latitude
      t.string :longitude
      t.string :url
      t.string :image_url
      t.string :areaname
      t.string :prefname

      t.timestamps null: false
    end
  end
end
