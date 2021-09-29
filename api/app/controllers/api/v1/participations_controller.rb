class Api::V1::ParticipationsController < ApplicationController
    def index
        @participations = Participation.where(card_id: params[:card_id])
        #ユーザーの情報もparticipationのjsonファイルから取れるようにしておく
        render json: @participations.to_json(:include => [:user]), status: 200
    end

    def create
        participation = Participation.new(participation_params)
        if participation.save
            render json: '作成に成功しました', status: 200
        else
            render json: '作成に失敗しました', status: 500
        end
    end

    def show
        participation = Participation.find_by(id: params[:id])
        unless @participation
            render json: participation, status: 200
        end
    end

    def update
        participation = Participation.find_by(id: params[:id])
        if participation.update(participation_params)
          render json: '更新に成功しました', status: 200
        else
          render json: '更新に失敗しました', status: 500
        end
    end

    def destroy
        participation = Participation.find(params[:id])
        if participation.destroy
          render json: '削除に成功しました', status: 200
        else
          render json: '削除に失敗しました', status: 500
        end
      end

    private

    def participation_params
        params.require(:participation).permit(:card_id, :user_id, :challenge_id)
    end
end