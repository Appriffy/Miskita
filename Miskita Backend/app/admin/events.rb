ActiveAdmin.register Event do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
permit_params :title, :access_code, :image, :client_email, :client_name, :start_time, :end_time, :server_id

filter :server
filter :title
filter :access_code
filter :client_email
filter :client_name
filter :start_time
filter :end_time
filter :created_at
filter :updated_at

index do
  selectable_column
  id_column
  column :server
  column :title
  column :access_code
  column :client_email
  column :client_name
  column :start_time
  column :end_time
  column :created_at
  column :updated_at
  actions
end

form multipart: true do |f|
	f.inputs do
		f.input :server
		f.input :title
		f.input :access_code
		f.input :image
		f.input :client_email
    f.input :client_name
		f.input :start_time, as: :datetime_picker
    f.input :end_time, as: :datetime_picker
	end
	f.actions
end

end
