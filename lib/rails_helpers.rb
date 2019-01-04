module RailsHelpers

  protected

    def helpers
      ActionController::Base.helpers
    end


    def routes
      Rails.application.routes.url_helpers
    end


    def render_to_string(partial, locals = {})
      helpers.raw ApplicationController.new.render_to_string(partial: partial, locals: locals)
    end
end
