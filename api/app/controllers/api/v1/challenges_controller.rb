class Api::V1::ChallengesController < ApplicationController
    def index
        @challenges = Challenge.where(user_id: params[:user_id]).where(is_done: false).order(:id)
        render json: @challenges, status: 200
    end

    def create
        challenge = Challenge.new(challenge_params)
        if challenge.save
            render json: challenge, status: 200
        else
            render json: '作成に失敗しました', status: 500
        end
    end

    def show
        challenge = Challenge.find_by(id: params[:id])
        unless @challenge
            render json: challenge, status: 200
        end
    end

    def update
        challenge = Challenge.find_by(id: params[:id])
        if challenge.update(challenge_params)
          render json: '更新に成功しました', status: 200
        else
          render json: '更新に失敗しました', status: 500
        end
    end

    def destroy
        challenge = Challenge.find(params[:id])
        if challenge.destroy
          render json: '削除に成功しました', status: 200
        else
          render json: '削除に失敗しました', status: 500
        end
      end

    private

    def challenge_params
        params.require(:challenge).permit(:title, :detail, :goal, :continuation, :cleared, :is_started, :is_done, :start_date, :end_date,:user_id, :done_at)
    end
end