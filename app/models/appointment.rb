# TODO: need to validate/escape "notes" field for security?

class Appointment < ActiveRecord::Base
    before_save { self.city = city.downcase }

    validates :city, inclusion: { in: ["San Francisco", "Chicago", "New York City"] }
    validate :scheduled_for_is_datetime?

    belongs_to :user
    validates :user, presence: true

    private

        def scheduled_for_is_datetime?
            if !scheduled_for.is_a?(DateTime) && !scheduled_for.is_a?(ActiveSupport::TimeWithZone)
              errors.add(:scheduled_for, 'must be a valid datetime') 
            end
        end
end