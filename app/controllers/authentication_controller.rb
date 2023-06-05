class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user

  def login
    @user = User.find_by_user_name(params[:user_name])
    if @user&.authenticate(params[:password])
      token = jwt_encode(payload: { user_id: @user.id })
      time = Time.now + 7.days
      render json: {
        token: token,
        exp: time.strftime("%d-%m-%Y %H:%M")
      }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end
