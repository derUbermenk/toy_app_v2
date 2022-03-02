class CreateToys < ActiveRecord::Migration[6.1]
  def change
    create_table :toys do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
