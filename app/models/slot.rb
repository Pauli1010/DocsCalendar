# frozen_string_literal: true

class Slot < ApplicationRecord
  enum occupancy: %w(open reserved vacation)
  belongs_to :doctor
  belongs_to :user, optional: true
end
