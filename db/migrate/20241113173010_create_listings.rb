class CreateListings < ActiveRecord::Migration[8.0]
  def change
    create_table :listings do |t|
      t.string :name
      t.text :description
      t.text :url

      t.timestamps
    end
  end
end
