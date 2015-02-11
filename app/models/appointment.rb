# TODO: need to validate/escape "notes" field for security?
# TODO: abstract core functionality into base model that appointments and requests
#  can inherit from
# TODO: add 4th state for "requested" and get rid of appointment requests?

class Appointment < ActiveRecord::Base
    include AASM

    scope :fulfilled_and_owned_by, ->(user) { fulfilled.where(user: user) }
    scope :fulfilled_as_student_and_not_owned_by, ->(user) { fulfilled.where.not(user: user).where(student: user) }
    scope :fulfilled_as_mentor_and_not_owned_by, ->(user) { fulfilled.where.not(user: user).where(mentor: user) }

    # TODO: necessary to downcase cities if all options are preset?
    # TODO: should probably be using enum/hash for city options

    validates :city, inclusion: { in: ["san francisco", "chicago", "new york city"] }
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

        # events for managing appointment requests
        event :request, :before => :attach_student do
            transitions :from => :created, :to => :requested, :guard => :only_has_student?
        end

        event :fulfill_request, :before => :attach_mentor do
            transitions :from => :requested, :to => :fulfilled, :guard => :has_student_and_mentor?
        end

        event :cancel_request, :before => :remove_student do
            transitions :from => :fulfilled, :to => :offered, :guard => :only_has_mentor?
        end

        # events for managing appointment offers
        event :offer, :before => :attach_mentor do
            transitions :from => :created, :to => :offered, :guard => :only_has_mentor?
        end

        event :fulfill_offer, :before => :attach_student do
            transitions :from => :offered, :to => :fulfilled, :guard => :has_student_and_mentor?
        end

        event :cancel_offer, :before => :remove_mentor do
            transitions :from => :fulfilled, :to => :requested, :guard => :only_has_student?
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

        # methods for managing student
        def attach_student(student)
            self.student = student if self.student.nil?
        end

        def remove_student(student)
            self.student = nil if self.student == student
        end

        def only_has_student?
            !self.student.nil? && self.mentor.nil?
        end

        # methods for managing mentor
        def attach_mentor(mentor)
            self.mentor = mentor if self.mentor.nil?
        end

        def remove_mentor(mentor)
            self.mentor = nil if self.mentor == mentor
        end

        def only_has_mentor?
            !self.mentor.nil? && self.student.nil?
        end

        def has_student_and_mentor?
            !self.student.nil? && !self.mentor.nil?
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