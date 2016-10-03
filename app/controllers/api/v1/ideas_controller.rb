module Api
  module V1
    class IdeasController < ApplicationController
      def index
        @ideas = Idea.all
      end
    end
  end
end
