class User < ApplicationRecord
  has_many :student_enrollments, class_name: 'Enrollment'
  # has_many :teachers, -> { distinct }, through: :student_enrollments
  has_many :teachers, through: :student_enrollments do
    def favorites
      where(enrollments: { favorite: true } ).distinct
    end
  end
  has_many :student_programs, -> { distinct }, through: :student_enrollments

  has_many :teacher_enrollments, class_name: 'Enrollment', foreign_key: :teacher_id
  # has_many :users, -> { distinct }, through: :teacher_enrollments
  has_many :users, through: :teacher_enrollments do
    def favorites
      where(enrollments: { favorite: true } ).distinct
    end
  end
  has_many :teacher_programs, -> { distinct }, through: :teacher_enrollments, primary_key: :teacher_id

  enum kind: {
    student: 0,
    teacher: 1,
    student_teacher: 2
  }

  # scope :favorites, -> { where(enrollments: {favorite: true}) }
  scope :classmates, -> (user){ joins(:student_programs).where(programs: { id: user.student_programs.select(:id) }).where.not(id: user.id).distinct }

  validate :change_of_kind

  def change_of_kind
    user = self
    if user.changed.include?('kind')
      if user.kind_was == 'student' && user.kind == 'teacher'
        errors.add(:base, "Kind can not be teacher because is studying in at least one program") if user.student_programs.any?
      elsif user.kind_was == 'teacher' && user.kind == 'student'
        errors.add(:base, "Kind can not be student because is teaching in at least one program") if user.teacher_programs.any?
      end
    end
  end
end
