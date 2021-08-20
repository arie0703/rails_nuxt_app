class Api::V1::CardsController < ApplicationController
    def index
        @cards = Card.all
    end
end
