class CreateLectures < ActiveRecord::Migration
  def self.up
    create_table :lectures do |t|
      t.string :name
      t.string :weeks
      t.integer :day
      t.integer :starts
      t.integer :ends
      t.string :room
      t.references :prof
      t.references :course
    end
  end

  def self.down
    drop_table :lectures
  end
end
