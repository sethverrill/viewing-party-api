class CreateViewingParties < ActiveRecord::Migration[7.1]
  def change
    create_table :viewing_parties do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.integer :movie_id
      t.string :movie_title
      t.references :host, null: false, foreign_key: { to_table: :users}

      t.timestamps
    end
  end
end