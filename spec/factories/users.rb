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

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
  end
end
