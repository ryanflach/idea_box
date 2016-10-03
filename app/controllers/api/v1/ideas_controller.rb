module Api
  module V1
    class IdeasController < ApplicationController
      def index
        @ideas = Idea.all
      end

      def create
        @idea = Idea.new(idea_params)
        render :show, status: 201 if @idea.save
      end

      private

      def idea_params
        params.permit(:title, :body)
      end
    end
  end
end
