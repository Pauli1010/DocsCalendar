# frozen_string_literal: true

RSpec.describe User, type: :model do
  subject { described_class.new }
  let!(:user) { create(:user, name: user_name, email: user_email) }
  let!(:admin) { create(:user, :admin) }
  let(:user_name) { Faker::Name.name }
  let(:user_email) { Faker::Internet.email }

  describe 'new user' do
    it 'has default data' do
      expect(subject.name.blank?).to be true
      expect(subject.email.blank?).to be true
      expect(subject.admin?).to be false
    end
  end

  describe 'factory user' do
    it 'user has default data' do
      expect(user.name).to eql user_name
      expect(user.email).to eql user_email
      expect(user.admin?).to be false
    end

    it 'admin has default data' do
      expect(admin.name).to eql 'Admin'
      expect(admin.admin?).to be true
    end
  end

  describe 'user is invalid' do
    it 'when email is already in base' do
      expect(User.find_by(email: user_email))
      expect(build(:user, email: user_email).valid?).to be false
    end
  end

  describe 'when user is destroyed' do
    let!(:doctor) { create(:doctor) }
    let(:slot) { Slot.where(doctor_id: doctor.id).last }

    it 'slots are being nulified' do
      slot.update(user: user)
      expect(slot.user).not_to be nil
      expect { user.destroy }.not_to change { Slot.count }
      slot.reload
      expect(slot.user).to be nil
    end
  end
end
