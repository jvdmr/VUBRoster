class CoursesController < ApplicationController
  require 'curb'
  require 'i18n'
  require 'hpricot'

  private
  def fetch url
    Curl::Easy.download url, "/tmp/ruby.html"
    tmp = File.read "/tmp/ruby.html"
  rescue Exception => e
    raise e
  end

  public
  def show
    @course = Course.find(params[:id])
  end

  def list
    @courses = Course.all
  end

  def edit
    @student = Student.find_by_id_or_name(params[:id])
    @course = CustomCourse.find(params[:courseid]) if params[:courseid]
    @course = CustomCourse.new unless @course
    respond_to do |format|
      format.html
    end
  end

  def save
    @student = Student.find_by_id_or_name(params[:id])
    @course = CustomCourse.find(params[:courseid]) if params[:courseid]
    @course = CustomCourse.new unless @course
    @lectures = []
    params[:lectures].each do |nr,lecture|
      if lecture[:id]
        lect = CustomLecture.find lecture[:id]
        if lect
          lect.update_attributes(lecture)
          @lectures << lect
        else
          @lectures << CustomLecture.new(lecture)
        end
      else
        @lectures << CustomLecture.new(lecture)
      end
    end
    respond_to do |format|
      if @course.update_attributes(params[:course])
        @lectures.each do |lecture|
          lecture.custom_course_id = @course.id
          lecture.save
        end
        format.html { redirect_to(show_url(@student.name)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def sync
    Lecture.delete_all
#     Prof.delete_all
#     Course.delete_all

#     locus_url = "http://locus.vub.ac.be:8080/reporting/spreadsheet?idtype=name&template=Mod%2BSS&objectclass=module%2Bgroup&identifier="
#     locus_url = "http://locus.vub.ac.be/reporting/spreadsheet?idtype=name&template=Mod%2BSS&objectclass=module%2Bgroup&identifier="
    locus_url = "http://splus.cumulus.vub.ac.be:1184/reporting/spreadsheet?idtype=name&template=Mod%2BSS&objectclass=module%2Bgroup&identifier="
    days = {"ma"=>0,"di"=>1,"wo"=>2,"do"=>3,"vr"=>4,"za"=>5,"zo"=>6}
    @courses = {}
    errormsg = ""

#     doc = Hpricot fetch("http://locus.vub.ac.be/20102011/opleidingsonderdelen_1011.htm")
#     doc = Hpricot fetch("http://locus.vub.ac.be/20112012/opleidingsonderdelen_1112.htm")
    doc = Hpricot fetch("http://splus.cumulus.vub.ac.be:1184/2evenjr/opleidingsonderdelen_evenjr.html")

    elems = doc/ :option

    elems.shift
    count = 0
    errormsg += "no data fetched<br />" if elems.empty?
    elems.each do |op|
      page = Hpricot fetch(locus_url + op.inner_html.strip.gsub(/ /, "+"))
      tables = page/ :table
      tables.reject! do |t|
        t.attributes["class"] !~ /spreadsheet|label-border-args/
      end

      until tables.empty? do
        tn = tables.shift
        name = tn.at("span[@class=label-1-0-0]").inner_html
        tc = []
        tc = tables.shift if tables.first.attributes["class"] =~ /spreadsheet/
          rows = tc.search("tr[@class='']")
        lectures = rows.map do |r|
          cols = r/ :td
          cols.map do |c|
            c.inner_html
          end
        end
        @courses[name] = lectures
      end
    end

    errormsg += "no courses found<br />" if @courses.empty?

    lecture_inserts = []
    ActiveRecord::Base.transaction do
      Hash[@courses.sort].each do |name, lectures|
        course = Course.find_by_id_or_name(name) || Course.create(:name => name)
        lectures.each do |l|
          profname = I18n.transliterate l[6]
          prof = Prof.find_by_id_or_name(profname) || Prof.create(:name => profname)
          l = l.map{|v| v.gsub(/&nbsp;/," ").gsub(/^\s*|\s*$/,"")}
          if l[1] && l[2] && l[3] && (l[1] != "") && (l[2] != "") && (l[3] != "") && (l[2].to_i != 0) && (l[3].to_i != 0)
            lecture_inserts << "(\"#{l[0].gsub(/"/,"'")}\", "+
                             "#{(days[l[1].gsub(/[^a-z]/,"")]||0)}, "+
                             "#{l[2].gsub(/"/,"'").gsub(/&nbsp;|:/,"").to_i}, "+
                             "#{l[3].gsub(/"/,"'").gsub(/&nbsp;|:/,"").to_i}, "+
                             "\"#{l[5].gsub(/"/,"'").gsub(/&nbsp;/,"")}\", "+
                             "\"#{l[7].gsub(/"/,"'")}\", "+
                             "#{prof.id}, "+
                             "#{course.id})"
          end
        end
      end
    end

    until lecture_inserts.empty? do
      sql = "insert into `lectures` (`name`, `day`, `starts`, `ends`, `weeks`, `room`, `prof_id`, `course_id`) values #{lecture_inserts.shift(1000).join(", ")}"
      Lecture.connection.execute sql
    end

    respond_to do |format|
      format.html { render :layout => false, :text => errormsg }
    end
  rescue Exception => e
    errormsg += e.message + "<br />"
    respond_to do |format|
      format.html { render :layout => false, :text => errormsg }
    end
  end
end
