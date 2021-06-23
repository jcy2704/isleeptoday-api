class AddOwnerToListings < ActiveRecord::Migration[6.1]
  def change
    add_column :listings, :owner, :string
  end
end
