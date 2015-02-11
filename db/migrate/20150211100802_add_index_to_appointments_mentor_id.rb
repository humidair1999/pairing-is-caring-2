class AddIndexToAppointmentsMentorId < ActiveRecord::Migration
  def change
    add_index :appointments, :mentor_id
  end
end
