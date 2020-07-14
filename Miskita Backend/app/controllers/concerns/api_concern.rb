module ApiConcern

    class NotFound < Exception
      def initialize(message = 'Not Found', *args)
        super
      end
  
      def http_status
        :not_found
      end
    end
  
    class Unauthorized < Exception
      def initialize(message = 'Unauthorized', *args)
        super
      end
  
      def http_status
        :unauthorized
      end
    end
  
    class UnprocessableEntity < Exception
      def initialize(message = 'Unprocessable Entity', *args)
        super
      end
  
      def http_status
        :unprocessable_entity
      end
    end
  
    def self.included(controller)
      controller.class_exec do
        clear_respond_to
        respond_to :json
  
        # skip_before_action :verify_authenticity_token
  
        # because msavin can't read a fucking error message
        # before_action :ensure_format!
        # before_action :authenticate_user!
  
        rescue_from Exception do |exc|
          status = exc.respond_to?(:http_status) ? exc.http_status :
            ActionDispatch::ExceptionWrapper.status_code_for_exception(
              exc.class.name )
          json = { errors: [ exc.message ] }
  
          if status.is_a?(Symbol)
            status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
          end
  
          if status.to_s[0] == '5'
            Rails.logger.error([exc.message].concat(exc.backtrace) * "\n")
            json[:backtrace] = exc.backtrace if !Rails.env.production?
          end
  
          render(json: json, status: status)
        end
  
        rescue_from ActiveRecord::RecordInvalid do |exc|
          Rails.logger.error(exc.message)
          Rails.logger.error(exc.record.errors.to_json)
          render status: 422, json: { errors: exc.record.errors }
        end
  
      end
    end
  
    protected
  
    def ensure_format!
      unless request.accepts.include?(Mime::Type.lookup('application/json'))
        raise(
          ActionController::UnknownFormat,
          <<-MESSAGE.strip.gsub(?\n, '').squeeze(' ')
            This API is JSON only: be sure to include application/json in your
            Accept header!
          MESSAGE
        )
      end
    end
  
    def respond_with(data, opts = {})
      opts = opts.with_indifferent_access.merge(current_user: current_user)
      render json: Serializer.build(data, opts)
    end
  end
  