class CreateProfs < ActiveRecord::Migration
  def self.up
    create_table :profs do |t|
      t.string :name
    end
    add_index(:profs, :name, :unique => true)
  end

  def self.down
    drop_table :profs
  end
end
