# frozen_string_literal: true

class Slot < ApplicationRecord
  enum occupancy: %w(open reserved vacation)
  belongs_to :doctor
  belongs_to :user, optional: true

  scope :slots_for_day, -> (date) { where(slot_date: date) }
end
