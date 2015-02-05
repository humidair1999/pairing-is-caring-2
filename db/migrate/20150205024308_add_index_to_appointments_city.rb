class AddIndexToAppointmentsCity < ActiveRecord::Migration
  def change
    add_index :appointments, :city
  end
end
