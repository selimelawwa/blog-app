class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|

      t.references :user
      t.references :article
      t.timestamps
    end
  end
end
