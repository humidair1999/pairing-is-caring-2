# TODO: need to validate/escape "notes" field for security?
# TODO: abstract core functionality into base model that appointments and requests
#  can inherit from
# TODO: add 4th state for "requested" and get rid of appointment requests?

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

        event :complete, :before => :mark_as_complete, :after => :request_feedback do
            transitions :from => :fulfilled, :to => :completed, :guard => :has_been_completed?
        end
    end

    private

        def scheduled_for_is_datetime?
            if !scheduled_for.is_a?(DateTime) && !scheduled_for.is_a?(ActiveSupport::TimeWithZone)
              errors.add(:scheduled_for, 'must be a valid datetime') 
            end
        end

        def attach_student(student)
            p 'attach ' + student
        end

        def has_student?
            p 'check to see if there\'s a student associated with the appointment'
            true
        end

        def mark_as_complete
            p 'require student to mark the session as complete'
        end

        def has_been_completed?
            p 'check to see if session was successfully marked as complete'
            true
        end

        def request_feedback
            p 'request feedback on session from student'
        end
end