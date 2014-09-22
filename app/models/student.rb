class Student < ActiveRecord::Base
  has_and_belongs_to_many :courses, :class_name => "Course"
  has_many :custom_courses

  validates_uniqueness_of :name

  def all_courses
    courses + custom_courses
  end

  def lectures week=nil, day=nil
    l = all_courses.map{|c| c.lectures}.flatten #.select{|l| not l.deleted }
    #     puts "week: #{week}"
    #     puts l.map{|le| "#{le.weeks} -=- #{le.course.name}"}.join("\n")
    if week 
      if day
        l.select{|lecture| (lecture.week_nrs.member? week.to_i) && (lecture.day == day)}.sort{|a,b| a.starts <=> b.starts}
      else
        l.select{|lecture| lecture.week_nrs.member? week.to_i}
      end
    else
      l
    end
  end

	def all_lectures
		l = all_courses.map{|c| c.lectures}.flatten #.select{|l| not l.deleted }
    all = {}
    (1..52).map do |week|
      all[week] = l.select{|lecture| lecture.week_nrs.member? week.to_i}
    end
    all
	end

  def self.find_by_id_or_name id
    if id.to_i == 0
      Student.find(:first, :conditions => ["name = ?", id])
    else
      Student.find id
    end
  end
end
