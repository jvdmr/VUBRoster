class CreateCustomCourses < ActiveRecord::Migration
  def self.up
    create_table :custom_courses do |t|
      t.string :name
      t.references :student

      t.timestamps
    end
  end

  def self.down
    drop_table :custom_courses
  end
end
