class AddIndexToAppointmentsUserId < ActiveRecord::Migration
  def change
    add_index :appointments, :user_id
  end
end
