class AddStatusToBeerDispatches < ActiveRecord::Migration[7.2]
  def change
    add_reference :beer_dispatches, :status, null: true, foreign_key: true
  end
end
