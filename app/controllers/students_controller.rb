class StudentsController < ApplicationController
  require "icalendar"
  require "date"
  require "tzinfo"

  def list
    @students = Student.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
    respond_to do |format|
      format.html
    end
  end

  def show
    @student = Student.find_by_id_or_name params[:id] if params[:id]

    @currentweek = Lecture.currentweek

    @week = params[:week] || @currentweek
    @week = nil if @week.to_i == 0

    respond_to do |format|
      if @student
        format.html
      else
        format.html { redirect_to index_url }
      end
    end
  end

  def day
    @student = Student.find_by_id_or_name params[:id] if params[:id]
    @today = true
    @week = Lecture.currentweek
    @day = ((Time.now.strftime("%w").to_i - 1) % 7).to_i
    dotw = ["ma","di","wo","do","vr","za","zo"]

    if params[:week] && params[:week].to_i != 0
      @week = params[:week]
      @today = false
    end

    if params[:day] && dotw.include?(params[:day])
      @day = dotw.index params[:day]
      @today = false
    end

    respond_to do |format|
      if @student
        lectures = @student.lectures(@week, @day)
        format.html { render :layout => false, :text => (@today ? "" : "#{dotw[@day]} week #{@week}: ") + (lectures.empty? ? "geen les!" : lectures.join(" || ")) }
      else
        format.html { render :layout => false, :text => "Student not found - go to http://uurrooster.phoenix.rave.org/edit to create a new account, then try again" }
      end
    end
  end

  def now
    @student = Student.find_by_id_or_name params[:id] if params[:id]
    @week = Lecture.currentweek
    @day = ((Time.now.strftime("%w").to_i - 1) % 7).to_i
    @now = Time.now.strftime("%H%M").to_i

    respond_to do |format|
      if @student
        lectures = @student.lectures(@week, @day).select{|lecture| lecture.starts == @now || lecture.ends == @now || (lecture.starts..lecture.ends).member?(@now) }
        format.html { render :layout => false, :text => (lectures.empty? ? "geen les!" : lectures.join(" || ")) }
      else
        format.html { render :layout => false, :text => "Student not found - go to http://uurrooster.phoenix.rave.org/edit to create a new account, then try again" }
      end
    end
  end

  def ical
    @student = Student.find_by_id_or_name params[:id] if params[:id]
    if @student
      @cal = Icalendar::Calendar.new

      tz = TZInfo::Timezone.get('Europe/Brussels')

      all_lects = @student.all_lectures

      (1..52).each do |week|
        all_lects[week].each do |lecture|
          @cal.event do
            dtstart tz.local_to_utc(lecture.starts_t(week) + 364*24*60*60).strftime("%Y%m%dT%H%M%S")
            dtend tz.local_to_utc(lecture.ends_t(week) + 364*24*60*60).strftime("%Y%m%dT%H%M%S")
            summary lecture.name
            location lecture.room
            klass "PUBLIC"
          end
        end if all_lects[week]
      end

      @cal.publish

      headers['Content-Type'] = "text/calendar; charset=UTF-8"
      render :layout => false, :text => @cal.to_ical
    else
      redirect_to index_url
    end
  end

  def edit
    @student = (params[:id] && Student.find_by_id_or_name(params[:id])) || Student.new
    @courses = Course.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
    respond_to do |format|
      format.html
    end
  end

  def save
    @student = (params[:oldname] && Student.find_by_id_or_name(params[:oldname])) || (params[:student][:name] && Student.find_by_id_or_name(params[:student][:name])) || Student.new
    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to(show_url(params[:student][:name].downcase)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def add_course
    @student = Student.find_by_id_or_name params[:id]
    @student.courses << Course.find(params[:course])
    @courses = Course.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
    respond_to do |format|
      format.html { redirect_to edit_url(params[:id]) }
      format.js
    end
  end

  def remove_course
    @student = Student.find_by_id_or_name params[:id]
    @student.courses.delete Course.find(params[:course])
    @courses = Course.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
    respond_to do |format|
      format.html { redirect_to edit_url(params[:id]) }
      format.js
    end
  end

  def remove_custom_course
    @student = Student.find_by_id_or_name params[:id]
    @courses = Course.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
    course = CustomCourse.find params[:course]
    course.lectures.each do |lecture|
      lecture.destroy
    end
    course.destroy
    respond_to do |format|
      format.html { redirect_to edit_url(params[:id]) }
      format.js
    end
  end

end
