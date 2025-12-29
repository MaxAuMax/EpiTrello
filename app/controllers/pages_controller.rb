class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing]

  def landing
    # Public landing page - no authentication required
  end
end
