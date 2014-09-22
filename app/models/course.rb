class Course < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :lectures
  has_and_belongs_to_many :students

  def path
    course_path id
  end

  def remove_path name
    remove_course_path name, id
  end

  def self.find_by_id_or_name id
    if id.to_i == 0
      Course.find(:first, :conditions => ["name = ?", id])
    else
      Course.find id
    end
  end
end
