class CreateCoursesStudentsJoin < ActiveRecord::Migration
  def self.up
    create_table :courses_students, :id => false do |t|
      t.references :course
      t.references :student
    end

    add_index(:courses_students, [:course_id, :student_id], :unique => true)
  end

  def self.down
    drop_table :courses_students
  end
end
