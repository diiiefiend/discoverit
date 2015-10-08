module Api
  class SubsController < ApplicationController
    wrap_parameters false

    before_action :ensure_moderator, only: [:edit, :update, :destroy]

    def index
      @subs = Sub.all.order(last_activity_stamp: :desc)
      render :index
    end

    def new
      @sub = Sub.new
      render :new
    end

    def create
      @sub = current_user.modded_subs.new(sub_params)

      if @sub.save
        redirect_to subs_url
      else
        flash.now[:errors] = @sub.errors.full_messages
        render :new
      end
    end

    def edit
      @sub = current_sub
      render :edit
    end

    def update
      @sub = current_sub
      if @sub.update(sub_params)
        redirect_to sub_url(@sub)
      else
        flash.now[:errors] = @sub.errors.full_messages
        render :edit
      end
    end

    def show
      @sub = current_sub

      render :show
    end

    def destroy
      current_sub.delete
      redirect_to subs_url
    end

    private

    def sub_params
      params.require(:sub).permit(:title, :description)
    end

    def ensure_moderator
      redirect_to subs_url unless current_sub.mod == current_user
    end

    def current_sub
      Sub.includes(:posts).find(params[:id])
    end
  end
end