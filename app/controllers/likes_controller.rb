class LikesController < ApplicationController

  def create
    Like
    .find_or_initialize_by(:superhero_id => params[:superhero_id], :ip => request.remote_ip)
    .update_attributes!(:value => params[:like][:value])

    render plain: "ok"
  end

  private
  def like_params
    params.require(:like).permit(:value, :ip)
  end

end
