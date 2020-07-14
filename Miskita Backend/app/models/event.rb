class Event < ApplicationRecord
	has_many :watchers, dependent: :destroy
	has_many :users, through: :watchers
  	belongs_to :server
  	#Validations
  	validates :title, presence: true
	validates :access_code, presence: true, uniqueness: true
	validate :validate_starttime, if: :start_time_changed?
	validate :validate_endtime, if: :end_time_changed?

	mount_uploader :image, ImageUploader

  	after_initialize :init

  	def init
  		self.server_id ||= 1
		self.start_time ||= DateTime.now
		self.end_time ||= DateTime.now
		if !self.access_code.present?
    	  loop do
    		self.access_code = SecureRandom.hex(5)
    		break unless self.class.exists?(:access_code => access_code)
		  end
		end
	end
	
	def validate_starttime
		if start_time < DateTime.now
			errors[:start_time] << 'must be greater than current time!'
		end
	end

	def active?(time = DateTime.now)
		end_time > time
	end

	def validate_endtime
		if end_time < start_time
			errors[:end_time] << 'must be greater than start time!'
		end
	end

end
