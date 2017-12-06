class CartedProduct < ApplicationRecord
    belongs_to :user, optional: true
end
