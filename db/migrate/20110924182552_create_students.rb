class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string :name
    end
    add_index(:students, :name, :unique => true)
  end

  def self.down
    drop_table :students
  end
end
