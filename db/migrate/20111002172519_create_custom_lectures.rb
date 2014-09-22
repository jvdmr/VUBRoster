class CreateCustomLectures < ActiveRecord::Migration
  def self.up
    create_table :custom_lectures do |t|
      t.string :name
      t.string :weeks
      t.integer :day, :default => 0
      t.integer :starts, :default => 800
      t.integer :ends, :default => 1000
      t.string :room
      t.integer :custom_course_id

      t.timestamps
    end
  end

  def self.down
    drop_table :custom_lectures
  end
end
