class Api::V1::Auth::UserImgController < ApplicationController
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
        params.permit(:image)
    end
end