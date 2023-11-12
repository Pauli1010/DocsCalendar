# frozen_string_literal: true

RSpec.describe Doctor, type: :model do
  subject { described_class.new }
  let(:doctor) { create(:doctor, name: doctor_name, specialization: doctor_spec) }
  let(:doctor_name) { Faker::Name.name }
  let(:doctor_spec) { Doctor::SPECIALIZATION[rand(Doctor::SPECIALIZATION.length)] }
  let(:weekly_schedule) do
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

  let(:weekly_schedule_humanized) do
    {
      'Monday' => [
        "10:00 - 11:00",
        "11:00 - 12:00",
        "12:00 - 13:00"
      ],
      'Tuesday' => ['Not available'],
      'Wednesday' => ['Not available'],
      'Thursday' => [
        "14:00 - 15:00",
        "15:00 - 16:00",
        "16:00 - 17:00"
      ],
      'Friday' => [
        '14:00 - 15:00',
        '15:00 - 16:00',
        '16:00 - 17:00'
      ],
      'Saturday' => ['Not available'],
      'Sunday' => ['Not available'],
    }
  end

  describe 'new doctor' do
    it 'has default data' do
      expect(subject.name.blank?).to be true
      expect(subject.specialization.blank?).to be true
      expect(subject.working_days_summary).to be nil
      expect(subject.working_days_summary_humanized).to eql Hash.new
    end
  end

  describe 'factory doctor' do
    it 'has default data' do
      expect(doctor.name).to eql doctor_name
      expect(doctor.specialization).to eql doctor_spec
      # expect(doctor.working_days_summary).to eql weekly_schedule
      expect(doctor.working_days_summary_humanized).to eql weekly_schedule_humanized
    end
  end
end
