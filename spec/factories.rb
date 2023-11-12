# frozen_string_literal: true

FactoryBot.define do
  factory(:user, class: 'User') do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end

  factory(:doctor, class: 'Doctor') do
    name { Faker::Name.name }
    specialization { Doctor::SPECIALIZATION[rand(Doctor::SPECIALIZATION.length)] }
    working_days_summary do
      {
        'Monday' => {
          'slots' => [
            [Time.new(2010, 1, 1, 10, 00), Time.new(2010, 1, 1, 11, 00)],
            [Time.new(2010, 1, 1, 11, 00), Time.new(2010, 1, 1, 12, 00)],
            [Time.new(2010, 1, 1, 12, 00), Time.new(2010, 1, 1, 13, 00)]
          ]
        },
        'Thursday' => {
          'slots' => [
            [Time.new(2010, 1, 1, 14, 00), Time.new(2010, 1, 1, 15, 00)],
            [Time.new(2010, 1, 1, 15, 00), Time.new(2010, 1, 1, 16, 00)],
            [Time.new(2010, 1, 1, 16, 00), Time.new(2010, 1, 1, 17, 00)]
          ]
        },
        'Friday' => {
          'slots' => [
            [Time.new(2010, 1, 1, 14, 00), Time.new(2010, 1, 1, 15, 00)],
            [Time.new(2010, 1, 1, 15, 00), Time.new(2010, 1, 1, 16, 00)],
            [Time.new(2010, 1, 1, 16, 00), Time.new(2010, 1, 1, 17, 00)]
          ]
        }
      }
    end

    after(:create) do |doctor|
      doctor.create_slots(Date.current - 2.days)
    end
  end
end