class MigrateExistingUserStores < ActiveRecord::Migration[7.2]
  def up
    User.where.not(store_id: nil).find_each do |user|
      UserStore.find_or_create_by!(
        user_id: user.id,
        store_id: user.store_id
      )
    end
  end

  def down
    UserStore.delete_all
  end
end