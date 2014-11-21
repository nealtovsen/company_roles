# == Schema Information
#
# Table name: company_users
#
#  id         :integer          not null, primary key
#  company_id :integer
#  user_id    :integer
#  roles      :string(255)      is an Array
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#

class CompanyUser < ActiveRecord::Base
  belongs_to :user, inverse_of: :company_users
  belongs_to :company, inverse_of: :company_users

  validates_presence_of :user
  validates_presence_of :company
  validate :validate_roles
  validate :no_duplicate_roles
  validate :ensure_role
  after_initialize :default_values

  # returns the role if added, or nil if already exists
  def add_role(role)
    return nil if self.roles.include? role
    self.roles << role
    role
  end

  # returns the role if removed, or nil if not found
  def remove_role(role)
    return nil unless self.roles.include? role
    self.roles.delete role
    role
  end

  def has_role?(role)
    self.roles.include? role
  end

  private

  def validate_roles
    if !roles.is_a?(Array) || roles.detect { |d| !Role::ALL_ROLES.include?(d) }
      errors.add(:roles, :invalid)
    end
  end

  def ensure_role
    errors.add(:roles, 'must have at least one') if roles.empty?
  end

  def no_duplicate_roles
    role_count_hash = Hash.new(0)
    roles.each { |e| role_count_hash[e] += 1 }
    role_count_hash.each do |role|
      errors.add(:roles, "duplicate value: #{role[0]}") unless role[1] == 1
    end
  end

  def default_values
    self.roles ||= [Role::DEFAULT_ROLE]
  end

end
