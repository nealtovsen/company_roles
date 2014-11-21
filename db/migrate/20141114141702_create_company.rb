class CreateCompany < ActiveRecord::Migration
  class Role
    EMPLOYEE = 'employee'
  end

  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :users do |t|
      t.string :email, null: false
      t.timestamps
    end

    create_table :company_users do |t|
      t.integer :company_id, null: false
      t.integer :user_id, null: false
      t.string :roles, array: true, null: false
      t.timestamps
    end

    add_index :company_users, [:company_id, :user_id], unique: true
  end
end
