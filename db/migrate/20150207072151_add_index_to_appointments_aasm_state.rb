class AddIndexToAppointmentsAasmState < ActiveRecord::Migration
  def change
    add_index :appointments, :aasm_state
  end
end
