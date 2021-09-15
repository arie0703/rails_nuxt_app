class Api::V1::Auth::UserController < ApplicationController
    def show
        @user = User.find_by(id: params[:id])
        render json: @user, status: 200
    end
end