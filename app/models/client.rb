class Client < ApplicationRecord
  devise :two_factor_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end
