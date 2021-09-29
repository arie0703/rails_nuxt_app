class Participation < ApplicationRecord
    belongs_to :user
    belongs_to :card
    belongs_to :challenge
end
