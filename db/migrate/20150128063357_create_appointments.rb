class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :scheduled_for
      t.string :city
      # t.references :student
      # t.references :mentor

      t.timestamps
    end
  end
end
