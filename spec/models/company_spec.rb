# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe 'Company' do
  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:company) { create :company, users: [user2] }

  describe 'adding and removing users' do

    describe 'adding a user' do
      before :each do
        company.users << user1
      end
      it 'adds users to the company' do
        expect(company.users).to eq [user2, user1]
      end
    end

    it 'removes users' do
      company.users.delete user2
      expect(company.users).to be_empty
    end
  end

  describe '#users_with_role' do
    it 'returns the users' do
      user1.add_role_at!(Role::ADMIN, company)
      expect(company.users_with_role(Role::EMPLOYEE)).to eq [user2]
      expect(company.users_with_role(Role::ADMIN)).to eq [user1]
      expect(company.users_with_role('foo')).to eq []
    end
  end

end
