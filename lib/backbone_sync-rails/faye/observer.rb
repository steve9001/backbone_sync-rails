require 'backbone_sync-rails/faye/event'

module BackboneSync
  module Rails
    module Faye
      module Observer
        def after_update(model)
          broadcast_event(model, :update)
        end

        def after_create(model)
          broadcast_event(model, :create)
        end

        def after_destroy(model)
          broadcast_event(model, :destroy)
        end

        def after_touch(model)
          broadcast_event(model, :touch)
        end

        def broadcast_event(model, event)
          Event.new(model, event).broadcast
        rescue *NET_HTTP_EXCEPTIONS => e
          handle_net_http_exception e
        end

        def handle_net_http_exception(exception)
          ::Rails.logger.error("")
          ::Rails.logger.error("Backbone::Sync::Rails::Faye::Observer encountered an exception:")
          ::Rails.logger.error(exception.class.name)
          ::Rails.logger.error(exception.message)
          ::Rails.logger.error(exception.backtrace.join("\n"))
          ::Rails.logger.error("")
        end
      end
    end
  end
end
