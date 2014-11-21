# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Company < ActiveRecord::Base
  has_many :company_users, inverse_of: :company
  has_many :users, through: :company_users, source: :user

  def users_with_role(role)
    User.joins(:company_users).where('company_users.company_id = ? AND ? = ANY (company_users.roles)', self.id, role)
  end
end
