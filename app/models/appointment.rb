# TODO: need to validate/escape "notes" field for security?

class Appointment < ActiveRecord::Base
    include AASM

    before_save { self.city = city.downcase }

    validates :city, inclusion: { in: ["San Francisco", "Chicago", "New York City"] }
    validate :scheduled_for_is_datetime?

    belongs_to :user
    validates :user, presence: true

    aasm :whiny_transitions => false do
        state :available, :initial => true
        state :fulfilled
        state :completed

        event :fulfill, :before => :attach_student do
            transitions :from => :available, :to => :fulfilled, :guard => :has_student?
        end

        event :complete do
            transitions :from => :fulfilled, :to => :completed
        end
    end

    private

        def scheduled_for_is_datetime?
            if !scheduled_for.is_a?(DateTime) && !scheduled_for.is_a?(ActiveSupport::TimeWithZone)
              errors.add(:scheduled_for, 'must be a valid datetime') 
            end
        end

        def attach_student(student)
            p student
        end

        def has_student?
            false
        end
end