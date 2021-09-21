class Api::V1::CardsController < ApplicationController
    def index
        @cards = Card.all
    end

    def create
        card = Card.new(card_params)
        if card.save
            render json: '作成に成功しました', status: 200
        else
            render json: '作成に失敗しました', status: 500
        end
    end

    def show
        card = Card.find_by(id: params[:id])
      
        unless @card
            render json: card, status: 200
        end
    end

    def update
        card = Card.find_by(id: params[:id])
        if card.update(card_params)
          render json: '更新に成功しました', status: 200
        else
          render json: '更新に失敗しました', status: 500
        end
    end

    def destroy
        card = Card.find(params[:id])
        if card.destroy
          render json: '削除に成功しました', status: 200
        else
          render json: '削除に失敗しました', status: 500
        end
      end

    private

    def card_params
        params.require(:card).permit(:title, :detail, :goal, :user_id)
    end
end
