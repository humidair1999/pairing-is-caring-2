class CreateAppointmentRequests < ActiveRecord::Migration
  def change
    create_table :appointment_requests do |t|
      t.datetime :desired_for
      t.string :city
      t.text :notes

      t.belongs_to :user

      t.timestamps
    end
  end
end
