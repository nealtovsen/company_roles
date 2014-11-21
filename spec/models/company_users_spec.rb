require 'spec_helper'

describe 'CompanyUsers' do

  describe 'roles' do
    let(:user) { create :user }
    let(:company) { create :company, users: [user] }
    let(:company_user) { user.company_user_for(company) }

    subject { company_user }

    describe '#user' do
      it { is_expected.to respond_to :user }
      it { is_expected.to validate_presence_of :user }
    end

    describe '#company' do
      it { is_expected.to respond_to :company }
      it { is_expected.to validate_presence_of :company }
    end

    describe '#add_role' do
      it 'rejects invalid roles' do
        company_user.add_role('foo')
        expect(company_user).not_to be_valid
        expect(company_user.errors.count).to eq 1
        expect(company_user.errors[:roles]).to include 'is invalid'
      end

      it 'returns role on add' do
        expect(company_user.add_role(Role::ADMIN)).to eq Role::ADMIN
      end

      it 'returns nil on duplicate' do
        expect(company_user.add_role(Role::DEFAULT_ROLE)).to be_nil
      end
    end

    describe '#remove_role' do
      it 'removes a role' do
        company_user.remove_role(Role::DEFAULT_ROLE)
        expect(company_user.roles).to eq []
      end

      it 'returns the deleted role' do
        expect(company_user.remove_role(Role::DEFAULT_ROLE)).to eq Role::DEFAULT_ROLE
      end

      it 'returns nil when no role' do
        expect(company_user.remove_role(Role::ADMIN)).to be_nil
      end
    end

    describe '#has_role?' do
      it 'is true for assigned role' do
        expect(company_user.has_role?(Role::DEFAULT_ROLE)).to be_truthy
      end
      it 'is false for unassigned role' do
        expect(company_user.has_role?(Role::ADMIN)).to be_falsey
      end
    end

    describe '#roles' do
      it 'detects duplicates' do
        company_user.roles = [Role::DEFAULT_ROLE, Role::DEFAULT_ROLE]
        expect(company_user).not_to be_valid
        expect(company_user.errors.count).to eq 1
        expect(company_user.errors[:roles]).to include "duplicate value: #{Role::DEFAULT_ROLE}"
      end

      it 'requires at least one role' do
        company_user.roles = []
        expect(company_user).not_to be_valid
        expect(company_user.errors.count).to eq 1
        expect(company_user.errors[:roles]).to include 'must have at least one'
      end
    end
  end

end