class CreateBeerReturns < ActiveRecord::Migration[7.2]
  def change
    create_table :beer_returns do |t|
      t.references :loading_order, null: false, foreign_key: true
      t.datetime :return_date

      t.timestamps
    end
  end
end
