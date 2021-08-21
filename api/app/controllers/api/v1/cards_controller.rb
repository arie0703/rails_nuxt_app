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

    private

    def card_params
        params.require(:card).permit(:title, :detail, :goal, :continuation, :cleared, :is_started, :is_done, :start_date, :end_date)
    end
end
