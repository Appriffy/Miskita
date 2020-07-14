class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action :set_time_zone

	def fallback_index_html
  		render :file => 'public/index.html'
	end

	private
	def set_time_zone
		if current_admin_user.present? && current_admin_user.time_zone.present?
			Time.zone = current_admin_user.time_zone
		else
			min = cookies["timezone"].to_i
			Time.zone = ActiveSupport::TimeZone[-min.minutes]
		end
	end
end
