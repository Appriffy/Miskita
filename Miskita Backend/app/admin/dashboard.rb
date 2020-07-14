ActiveAdmin.register_page "Dashboard" do
# Add page on 1st page
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
        column do
            panel "AdminUsers", :class => 'center_text' do
                para link_to("#{AdminUser.count}", admin_admin_users_path), :class => 'box_para'
            end
        end
        column do
            panel "Events", :class => 'center_text' do
                para link_to("#{Event.count}", admin_events_path), :class => 'box_para'
            end
        end
        column do
            panel "Servers", :class => 'center_text' do
                para link_to("#{Server.count}", admin_servers_path), :class => 'box_para'
            end
        end
        column do
            panel "Users", :class => 'center_text' do
                para link_to("#{User.count}", admin_users_path), :class => 'box_para'
            end
        end
    end
  end

end