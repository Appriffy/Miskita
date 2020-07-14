ActiveAdmin.register AdminUser do
  permit_params :email, :time_zone, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    # column :time_zone
    # column :current_sign_in_at
    # column :sign_in_count
    column :created_at
    column :updated_at
    actions
  end

  filter :email
  # filter :time_zone
  # filter :current_sign_in_at
  # filter :sign_in_count
  filter :created_at
  filter :updated_at

  form do |f|
    # f.object.time_zone ||= 'UTC'
    f.inputs do
      f.input :email
      # f.input :time_zone
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
