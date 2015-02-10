# TODO: need to validate/escape "notes" field for security?
# TODO: abstract core functionality into base model that appointments and requests
#  can inherit from
# TODO: add 4th state for "requested" and get rid of appointment requests?

class Appointment < ActiveRecord::Base
    include AASM

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
            self.student = student
        end

        def has_student?
            !self.student.nil?
        end

        def attach_mentor(mentor)
            self.mentor = mentor
        end

        def has_mentor?
            !self.mentor.nil?
        end

        def attach_student_or_mentor(opts)
            if opts.key?(:student) && self.student.nil?
                self.student = opts[:student]
            end

            if opts.key?(:mentor) && self.mentor.nil?
                self.mentor = opts[:mentor]
            end
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