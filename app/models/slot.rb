# frozen_string_literal: true

class Slot < ApplicationRecord
  enum occupancy: %w(open reserved vacation)
  belongs_to :doctor
  belongs_to :user, optional: true

  scope :open_slots, -> { where(occupancy: 'open') }
  scope :reserved_slots, -> { where(occupancy: 'reserved') }
  scope :by_date, -> (date) { where(slot_date: date) }
  scope :by_doctor, -> (doctor_id) { where(doctor_id: doctor_id) }
  scope :by_user, -> (user_id) { where(user_id: user_id) }

  def reserve(current_user)
    self.update_columns(user: current_user, occupancy: 'reserved')
  end

  def free_up
    self.update_columns(user: nil, occupancy: 'open')
  end

  def add_message(message)
    self.update_column('user_message', message)
  end
end
