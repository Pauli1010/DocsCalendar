# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :appointments,
           foreign_key: "user_id",
           class_name: "Slot",
           dependent: :nullify

  validates :email, uniqueness: true, on: :create
end
