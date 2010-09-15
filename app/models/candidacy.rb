class Candidacy < ActiveRecord::Base
  belongs_to :politician
  belongs_to :race
end