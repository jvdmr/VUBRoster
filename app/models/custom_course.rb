class CustomCourse < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :student
  has_many :lectures, :class_name => "CustomLecture"

  def path
    edit_custom_course_path student.name, id
  end

  def remove_path name
    remove_custom_course_path name, id
  end
end
