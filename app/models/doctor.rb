# frozen_string_literal: true

class Doctor < ApplicationRecord
  SPECIALIZATION =  %w(cardiologist general_practitioner optitian pulmunologist) # Specializations dictionary simulation
  WEEK_DAYS = Date::DAYNAMES.rotate(1) # adjust to start from Monday
  has_many :slots, dependent: :destroy

  after_create :create_slots

  # Method used to create slots in calendar
  # Ultimately to be added as admin functionality
  # Currently used for seeding for 2 weeks from stat date
  def create_slots(start_date = Date.current)
    return if working_days.none?

    stop_date = start_date + 14.days

    while start_date <= stop_date do
      if working_days.include?(Date::DAYNAMES[start_date.cwday]) && slots.slots_for_day(start_date).none?
        weekday = Date::DAYNAMES[start_date.cwday]
        working_days_summary.dig(weekday, 'slots').each do |s|
          slots.create(
            doctor: self,
            slot_date: start_date,
            start_time: s.first.to_datetime,
            end_time: s.first.to_datetime,
            occupancy: 'open'
          )
        end
      end

      start_date += 1.day
    end

  end

  def working_days
    return Slot.none unless working_days_summary

    working_days_summary.keys
  end

  def working_days_summary_humanized
    working_schedule = {}
    WEEK_DAYS.each do |weekday|
      working_schedule[weekday] = if working_days_summary.dig(weekday, 'slots')
                                    working_days_summary.dig(weekday, 'slots').map { |arr| "#{arr.first.to_datetime.strftime "%H:%M"} - #{arr.last.to_datetime.strftime "%H:%M"}" }
                                  else
                                    ['Not available']
                                  end
    end

    working_schedule
  rescue => e
    # TODO: Add log to save info on handled error
    return {}
  end
end
