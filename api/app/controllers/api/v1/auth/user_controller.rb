class Api::V1::Auth::UserController < ApplicationController
    def show
        @user = User.find_by(id: params[:id])
        render json: @user, status: 200
    end

    def update
        user = User.find_by(id: params[:id])
        if user.update(user_params)
          render json: '更新に成功しました', status: 200
        else
          render json: '更新に失敗しました', status: 500
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :name, :image)
    end
end