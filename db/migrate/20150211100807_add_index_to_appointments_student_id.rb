class AddIndexToAppointmentsStudentId < ActiveRecord::Migration
  def change
    add_index :appointments, :student_id
  end
end
