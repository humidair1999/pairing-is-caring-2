class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :scheduled_for
      t.string :city
      t.text :notes

      t.belongs_to :user

      t.string :aasm_state

      t.timestamps
    end
  end
end
