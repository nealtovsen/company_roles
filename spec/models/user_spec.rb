# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe 'User' do

  describe 'company roles' do
    let(:company) { create :company }
    let(:user) { create :user, companies: [company] }
    let(:user2) { create :user }

    describe '#all_roles_at' do
      it 'enumerates roles' do
        expect(user.all_roles_at(company).size).to eq 1
      end
    end

    describe '#has_role_at?' do
      it 'is true when has the role' do
        expect(user.has_role_at?(Role::EMPLOYEE, company)).to be_truthy
      end
      it 'is false when does not have the role' do
        expect(user.has_role_at?(Role::ADMIN, company)).to be_falsey
      end
      it 'returns false when no association' do
        expect(user2.has_role_at?(Role::ADMIN, company)).to be_falsey
      end
    end

    describe '#add_role_at!' do
      it 'adds the role' do
        expect(user.add_role_at!(Role::ADMIN, company)).to eq Role::ADMIN
      end
      it 'is false when does not have the role' do
        expect(user.add_role_at!(Role::EMPLOYEE, company)).to be_nil
      end
      it 'creates company_user when no association' do
        expect(user2.add_role_at!(Role::ADMIN, company)).to eq Role::ADMIN
        user2.save
        user2.reload
        expect(user2.has_role_at?(Role::ADMIN, company)).to be_truthy
      end
    end

    describe '#remove_role_at!' do
      it 'removes the role' do
        expect(user.remove_role_at!(Role::EMPLOYEE, company)).to eq Role::EMPLOYEE
      end
      it 'is false when does not have the role' do
        expect(user.remove_role_at!(Role::ADMIN, company)).to be_nil
      end
      it 'returns nil when no association' do
        expect(user2.remove_role_at!(Role::ADMIN, company)).to be_nil
      end
      it 'removes the CompanyUser with last role' do
        user.remove_role_at!(Role::EMPLOYEE, company)
        user.save
        user.reload
        expect(user.company_users.length).to eq 0
      end
    end
  end

end
