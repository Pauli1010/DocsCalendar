# frozen_string_literal: true

RSpec.describe User, type: :model do
  subject { described_class.new }
  let(:user) { create(:user, name: user_name, email: user_email) }
  let(:user_name) { Faker::Name.name }
  let(:user_email) { Faker::Internet.email }

  describe 'new user' do
    it 'has default data' do
      expect(subject.name.blank?).to be true
      expect(subject.email.blank?).to be true
    end
  end

  describe 'factory user' do
    it 'has default data' do
      expect(user.name).to eql user_name
      expect(user.email).to eql user_email
    end
  end
end
