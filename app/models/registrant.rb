class Registrant < ActiveRecord::Base
  belongs_to :student
  belongs_to :workshop
end
