class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user,   only: :destroy

  def create
    @currentURI = request.referrer
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      # redirect_to root_url
      # redirect_to @currentURI
      # or new method from rails 5
      redirect_back(fallback_location: @currentURI)
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    @currentURI = "#{request.base_url}/users/#{current_user.id}"
    redirect_to request.referrer || @currentURI
     # redirect_to request.referrer || root_url
   end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    @currentURI = request.referrer
    redirect_to @currentURI if @micropost.nil?
  # redirect_to root_url if @micropost.nil?
end
end
