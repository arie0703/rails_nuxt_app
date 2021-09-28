class Api::V1::AlreadyParticipatedController < ApplicationController
    #ログイン中ユーザーがすでにチャレンジに参加しているかを判定し、jsonで返す
    def index
        participation = Participation.where(card_id: params[:card_id]).where(user_id: params[:user_id])
        if participation.empty?
            render json: false
        else
            render json: true
        end
    end
end