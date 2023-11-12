# frozen_string_literal: true

class User < ApplicationRecord
  has_many :appointments,
           foreign_key: "patient_id",
           class_name: "Slot",
           dependent: :nullify
end
