class Prof < ActiveRecord::Base
  has_many :lectures

  def self.find_by_id_or_name id
    if id.to_i == 0
      Prof.find(:first, :conditions => ["name = ?", id])
    else
      Prof.find id
    end
  end
end
