class UserProfilesController < ApplicationController

  # GET /user_profiles/1
  def view
    user = get_user
    
  end

  private
  def get_user
    params.require(:id)
  end

end
