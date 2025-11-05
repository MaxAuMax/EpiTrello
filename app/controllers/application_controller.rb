class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  respond_to :html, :turbo_stream

  def after_sign_in_path_for(resource)
    user_path(resource)
  end
end
