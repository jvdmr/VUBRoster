class CustomLecture < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :course, :class_name => "CustomCourse", :foreign_key => "custom_course_id"

  ORIGIN = Time.local(2011,9,19,0,0)

  def path
    edit_custom_course_path course.student.name, course.id
  end

  def prof
    false
  end

	def week_nrs
		self.weeks.gsub(/[^-,0-9]/, "").split(',').map{|range| range.split('-')}.map{|arr| (arr.first.to_i..arr.last.to_i).to_a}.flatten
	end

	def overlaps? other
		self != other and
			((self.starts..self.ends).member? other.starts or (other.starts..other.ends).member? self.starts) and
			self.starts != other.ends and
			self.ends != other.starts
	end

  def starts_t week=false
    week = Lecture.currentweek unless week
    time = ORIGIN + ((week.to_i - 1) * 7 * 24 * 60 * 60) + (self.day.to_i * 24 * 60 * 60)
    time + (((self.starts.to_i / 100) + (time.dst? ? 0 : 1)) * 60 * 60) + ((self.starts.to_i % 100) * 60)
  end

  def ends_t week=false
    week = Lecture.currentweek unless week
    time = ORIGIN + ((week.to_i - 1) * 7 * 24 * 60 * 60) + (self.day.to_i * 24 * 60 * 60)
    time + (((self.ends.to_i / 100) + (time.dst? ? 0 : 1)) * 60 * 60) + ((self.ends.to_i % 100) * 60)
  end

  def self.currentweek
    currenttime = Time.now # + 60*60*24*7*14 ## testing other dates than today
    currentweek = currenttime.strftime("%U").to_i
    currentweek - 37 > 0 ? currentweek - 37 : currentweek + 15
  end

  def to_s
    "#{starts_t(@week).strftime("%H:%M")}-#{ends_t(@week).strftime("%H:%M")} #{name} @ #{room}"
  end
end
