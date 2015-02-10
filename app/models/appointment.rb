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

    belongs_to :mentor, :class_name => 'User'
    belongs_to :student, :class_name => 'User'

    aasm :whiny_transitions => false do
        state :created, :initial => true
        state :requested
        state :offered
        state :fulfilled
        state :completed

        event :request, :before => :attach_student do
            transitions :from => :created, :to => :requested, :guard => :has_student?
        end

        event :offer, :before => :attach_mentor do
            transitions :from => :created, :to => :offered, :guard => :has_mentor?
        end

        event :fulfill, :before => :attach_student_or_mentor do
            transitions :from => [:created, :requested, :offered], :to => :fulfilled, :guard => :has_student_and_mentor?
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
            p 'attach student: ' + student
        end

        def has_student?
            p 'check to see if there\'s a student associated with the appointment'
            true
        end

        def attach_mentor(mentor)
            p 'attach mentor: ' + student
        end

        def has_mentor?
            p 'check to see if there\'s a mentor associated with the appointment'
            true
        end

        def attach_student_or_mentor(opts)
            # TODO: allow user to pass in hash to pass in one or both users
            p 'attach student or mentor: ' + opts
        end

        def has_student_and_mentor?
            p 'check to see if there are both a student and mentor associated with the appointment'
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