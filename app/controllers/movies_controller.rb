class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    # detect whether no params[] were passed that indicate filtering
    if params[:ratings].nil? && params[:commit] == "Refresh"
      session[:ratings] = nil
    end
    # detect whether no params[] were passed that indicate sorting
    if params[:sort].nil? && params[:commit] == "Refresh"
      session[:sort] = nil
    end
  

    # determine if params or session has sort
    if params[:sort]
      @sort = params[:sort]
      session[:sort] = @sort
    elsif session[:sort]
      @sort = session[:sort]
    else 
      @sort = nil
    end

    # determine if params or session has ratings filtered
    if params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = @ratings
    elsif session[:ratings]
      @ratings = session[:ratings]
    else
      @ratings = nil
    end

    if (@ratings != nil) # checked a rating to filter
      @ratings_to_show = @ratings.keys
      @movies = Movie.with_ratings(@ratings_to_show).order(@sort)
    else
      @ratings_to_show = []
      @movies = Movie.all.order(@sort)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
