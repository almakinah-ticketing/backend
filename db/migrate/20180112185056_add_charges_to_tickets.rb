class AddChargesToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :charge, :string
  end
end
