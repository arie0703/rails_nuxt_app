class Challenge < ApplicationRecord
    has_one :participation, dependent: :destroy
end