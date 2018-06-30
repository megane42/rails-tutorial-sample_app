class MicropostsController < ApplicationController
  before_action :require_login,        only: [:create, :destroy]
  before_action :require_correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render "static_pages/home"
    end
  end

  def destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def require_correct_user
    unless current_user.microposts.find_by(id: params[:id])
      redirect_to root_url
    end
  end
end
