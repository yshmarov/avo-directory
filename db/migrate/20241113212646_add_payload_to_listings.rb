class AddPayloadToListings < ActiveRecord::Migration[8.0]
  def change
    add_column :listings, :payload, :jsonb
  end
end
