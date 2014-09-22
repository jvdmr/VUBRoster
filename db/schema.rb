# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111002172519) do

  create_table "courses", :force => true do |t|
    t.string "name"
  end

  add_index "courses", ["name"], :name => "index_courses_on_name", :unique => true

  create_table "courses_students", :id => false, :force => true do |t|
    t.integer "course_id"
    t.integer "student_id"
  end

  add_index "courses_students", ["course_id", "student_id"], :name => "index_courses_students_on_course_id_and_student_id", :unique => true

  create_table "custom_courses", :force => true do |t|
    t.string   "name"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_lectures", :force => true do |t|
    t.string   "name"
    t.string   "weeks"
    t.integer  "day"
    t.integer  "starts"
    t.integer  "ends"
    t.string   "room"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lectures", :force => true do |t|
    t.string  "name"
    t.string  "weeks"
    t.integer "day"
    t.integer "starts"
    t.integer "ends"
    t.string  "room"
    t.integer "prof_id"
    t.integer "course_id"
  end

  create_table "profs", :force => true do |t|
    t.string "name"
  end

  add_index "profs", ["name"], :name => "index_profs_on_name", :unique => true

  create_table "students", :force => true do |t|
    t.string "name"
  end

  add_index "students", ["name"], :name => "index_students_on_name", :unique => true

end
