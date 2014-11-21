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

class User < ActiveRecord::Base

  has_many :company_users, inverse_of: :user
  has_many :companies, through: :company_users, source: :company

  def all_roles_at(company_id)
    company_user = company_user_for(company_id)
    company_user.try(:roles).nil? ? [] : company_user.roles
  end

  def has_role_at?(role, company_id)
    all_roles_at(company_id).include? role
  end

  def add_role_at!(role, company)
    cu = company_user_for(company)
    if cu.nil?
      company_users.new(company: company, roles: [role])
      ret_val = role
    else
      ret_val = cu.add_role(role)
    end
    save!
    ret_val
  end

  def remove_role_at!(role, company)
    cu = company_user_for(company)
    return nil if cu.nil?
    ret_val = cu.remove_role(role)
    if cu.roles.length < 1
      cu.destroy
    else
      save!
    end
    ret_val
  end

  def company_user_for(company_id)
    company_users.find_by(company_id: company_id)
  end
end
