class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private
  def sign_up_params
    #デフォルトでは新規登録で登録されるカラムはパスワードとE-mail
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
