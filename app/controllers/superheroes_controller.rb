class SuperheroesController < ApplicationController

  def new
    @superhero = Superhero.new
    @form_url = superheroes_path
  end

  def edit
    @superhero = Superhero.find(params[:id])
    @form_url = superhero_path(@superhero)
  end

  def create
    @superhero = Superhero.new(superhero_params)
    if @superhero.save
      redirect_to @superhero
    else
      render 'new'
    end
    #render plain: params[:article].inspect
  end

  def update
    @superhero = Superhero.find(params[:id])
    revision = Revision.new do |r|
      r.superhero = @superhero
      if superhero_params[:name].present? && superhero_params[:name] != @superhero.name then r.name = @superhero.name end
      if superhero_params[:description].present? && superhero_params[:description] != @superhero.description then r.description = @superhero.description end
      if superhero_params[:image_url].present? && superhero_params[:image_url] != @superhero.image_url then r.image_url = @superhero.image_url end
      if superhero_params[:superpowers].present? && superhero_params[:superpowers] != @superhero.superpowers then r.superpowers = @superhero.superpowers end
      if superhero_params[:creator].present? && superhero_params[:creator] != @superhero.creator then r.creator = @superhero.creator end
      if superhero_params[:studio].present? && superhero_params[:studio] != @superhero.studio then r.studio = @superhero.studio end
    end
    if [revision.name, revision.description, revision.image_url, revision.superpowers, revision.creator, revision.studio].any? then revision.save end
    if @superhero.update(superhero_params)
      redirect_to @superhero
    else
      render 'edit'
    end
  end

  def destroy
    @superhero = Superhero.find(params[:id])
    @superhero.destroy

    redirect_to superheroes_path
  end

  def show
    @superhero = Superhero.find(params[:id])
    @user_like = Like.where(ip: request.remote_ip, superhero_id: params[:id]).first
    @likes = Like.where(superhero_id: params[:id])
    #@likes_avg = @likes.inject(0){|sum,x| sum + x } / @likes.length
  end

  def index
    @superheroes = Superhero.includes(:likes).group(:id).order(id: :desc).all
  end

  def search
    @q = params[:s]
    @results = Superhero.where("name LIKE ? OR superpowers LIKE ? OR creator LIKE ? OR studio LIKE ?", "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%") #name: params[:s])

  end

  def revisions
    @superhero = Superhero.find(params[:id])
    @revisions = @superhero.revisions.order(id: :desc)
    @now = Date.today
  end

  def reset_revision
    @superhero = Superhero.find(params[:id])
    @reset_revision = Revision.find(params[:rev_id])

    # revision = @superhero.revisions.new do |r|
    #   r.superhero = @superhero
    #   if reset_revision[:name] != @superhero.name then r.name = @superhero.name end
    #   if reset_revision[:description] != @superhero.description then r.description = @superhero.description end
    #   if reset_revision[:image_url] != @superhero.image_url then r.image_url = @superhero.image_url end
    #   if reset_revision[:superpowers] != @superhero.superpowers then r.superpowers = @superhero.superpowers end
    #   if reset_revision[:creator] != @superhero.creator then r.creator = @superhero.creator end
    #   if reset_revision[:studio] != @superhero.studio then r.studio = @superhero.studio end
    # end
    #if [revision.name, revision.description, revision.image_url, revision.superpowers, revision.creator, revision.studio].any? then revision.save end

    revision = Revision.new do |r|
      r.superhero = @superhero
      if @reset_revision[:name].present? then r.name = @superhero.name end
      if @reset_revision[:description].present? then r.description = @superhero.description end
      if @reset_revision[:image_url].present? then r.description = @superhero.description end
      if @reset_revision[:superpowers].present? then r.description = @superhero.description end
      if @reset_revision[:creator].present? then r.description = @superhero.description end
      if @reset_revision[:studio].present? then r.description = @superhero.description end
    end

    if @reset_revision[:name].present? then @superhero.name = @reset_revision[:name] end
    if @reset_revision[:description].present? then @superhero.description = @reset_revision[:description] end
    if @reset_revision[:image_url].present? then @superhero.image_url = @reset_revision[:image_url] end
    if @reset_revision[:superpowers].present? then @superhero.superpowers = @reset_revision[:superpowers] end
    if @reset_revision[:creator].present? then @superhero.creator = @reset_revision[:creator] end
    if @reset_revision[:studio].present? then @superhero.name = @reset_revision[:studio] end
    @superhero.save

    if [revision.name, revision.description, revision.image_url, revision.superpowers, revision.creator, revision.studio].any? then revision.save end
    @reset_revision.destroy

    redirect_to superhero_path(@superhero)
  end

  private
  def superhero_params
    params.require(:superhero).permit(:name, :description, :image_url, :superpowers, :creator, :studio)
  end

  def revision_params
    params.require(:revision).permit(:name, :description, :image_url, :superpowers, :creator, :studio)
  end

end
