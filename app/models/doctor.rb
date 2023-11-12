# frozen_string_literal: true

class Doctor < ApplicationRecord
  SPECIALIZATION =  %w(cardiologist general_practitioner optitian pulmunologist) # Specializations dictionary simulation
  WEEK_DAYS = Date::DAYNAMES.rotate(1) # adjust to start from Monday
  has_many :slots

  # Method used to create slots in calendar
  # Ultimately to be added as admin functionality
  # Currently used for seeding for 2 weeks from stat date
  def create_slots(start_date)

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
    # Add log to save info on handled error
    return {}
  end
end
