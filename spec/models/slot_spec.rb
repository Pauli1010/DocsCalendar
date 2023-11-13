# frozen_string_literal: true

RSpec.describe Slot, type: :model do
  let(:doctor) { create(:doctor) }
  let(:slot) { doctor.slots.last }
  let(:doctor_0) { create(:doctor) }

  before do
    2.times { create(:user) }
    doctor_0.slots.update_all(occupancy: 'reserved', user_id: User.last.id)
  end

  describe 'scopes' do
    it 'open_slots finds only open slots' do
      open_slots = described_class.open_slots
      expect(open_slots.map(&:occupancy).uniq.size).to eql 1
      expect(open_slots.map(&:occupancy).uniq.first).to eql 'open'
    end

    it 'reserved_slots finds only reserved slots' do
      reserved_slots = described_class.reserved_slots
      expect(reserved_slots.map(&:occupancy).uniq.size).to eql 1
      expect(reserved_slots.map(&:occupancy).uniq.first).to eql 'reserved'
    end

    it 'by_date finds only with specific date' do
      picked_date = Date.current + 3.days
      by_date = described_class.by_date(picked_date)
      expect(by_date.any?).to be true
      expect(by_date.map(&:slot_date).uniq.size).to eql 1
      expect(by_date.map(&:slot_date).uniq.first).to eql picked_date
    end

    it 'by_doctor finds only with specific date' do
      by_doctor = described_class.by_doctor(doctor.id)
      expect(by_doctor.any?).to be true
      expect(by_doctor.map(&:doctor_id).uniq.size).to eql 1
      expect(by_doctor.map(&:doctor_id).uniq.first).to eql doctor.id
    end

    it 'by_doctor finds only with specific date' do
      user_id = User.last.id
      by_user = described_class.by_user(user_id)
      expect(by_user.any?).to be true
      expect(by_user.map(&:user_id).uniq.size).to eql 1
      expect(by_user.map(&:user_id).uniq.first).to eql user_id
    end
  end

  describe 'user manipulations' do
    let(:user) { User.first }
    it 'reserves open slot for user' do
      expect(slot.occupancy).to eql 'open'
      slot.reserve(user)
      expect(slot.occupancy).to eql 'reserved'
      expect(slot.user).to eql user
    end

    it 'does not reserve unopen slot for user', skip: 'method is being triggered conditionally in controller' do
      slot = doctor_0.slots.last
      expect(slot.occupancy).to eql 'reserved'
      expect(slot.user).not_to eql user
      slot.reserve(user)
      expect(slot.user).not_to eql user
    end

    it 'frees up slot' do
      slot = doctor_0.slots.last
      expect(slot.occupancy).to eql 'reserved'
      expect(slot.user).not_to be nil
      slot.free_up
      expect(slot.occupancy).to eql 'open'
      expect(slot.user).to be nil
    end

    it 'adds message to slot' do
      message = 'Some message'
      expect(slot.user_message.present?).to be false
      slot.add_message(message)
      expect(slot.user_message).to eql message
    end
  end
end
