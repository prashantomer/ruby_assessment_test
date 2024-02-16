class Enrollment < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :teacher, foreign_key: :teacher_id, class_name: 'User'
  belongs_to :program
  belongs_to :student_program, foreign_key: :program_id, class_name: 'Program'
  belongs_to :teacher_program, foreign_key: :program_id, class_name: 'Program'
end
