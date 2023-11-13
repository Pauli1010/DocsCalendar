# frozen_string_literal: true

FactoryBot.define do
  factory(:user, class: 'User') do
    name { Faker::Name.name }
    email { Faker::Internet.email }

    trait :admin do
      name { 'Admin' }
      admin { true }
    end
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

    trait :no_working_days_summary do
      working_days_summary { nil }
    end
  end
end