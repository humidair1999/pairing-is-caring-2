# TODO: abstract core functionality into base model that appointments and requests
#  can inherit from

class AppointmentRequest < ActiveRecord::Base
    before_save { self.city = city.downcase }

    validates :city, inclusion: { in: ["San Francisco", "Chicago", "New York City"] }
    validate :desired_for_is_datetime?

    belongs_to :user
    validates :user, presence: true

    private

        def desired_for_is_datetime?
            if !desired_for.is_a?(DateTime) && !desired_for.is_a?(ActiveSupport::TimeWithZone)
              errors.add(:desired_for, 'must be a valid datetime') 
            end
        end
end