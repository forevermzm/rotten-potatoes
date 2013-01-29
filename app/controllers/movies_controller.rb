class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  	@all_ratings = Movie.all_ratings
    if params.include?(:commit)
      if params.include?(:ratings)
        session[:ratings]=params[:ratings]
        @movies = Movie.find(:all, :conditions => { :rating => params[:ratings].keys})
      else
        if session.include?(:ratings)
          session.delete(:ratings)
        end
        @movies = Movie.all
      end
	elsif params.include?:ratings
		if params.include?:sort
			@movies = Movie.find(:all , :conditions => {:rating => params[:ratings].keys}, :order => params[:sort])
		else
			@movies = Movie.find(:all , :conditions => {:rating => params[:ratings].keys})
		end
	else
  		if session.include?:sort
  			redirect_to :action => 'index', :sort => session[:sort]
  		elsif session.include?(:ratings)
        	redirect_to :action => 'index', :commit =>'Refresh', :ratings => session[:ratings]
		else
			@movies = Movie.all
		end
	end  	
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
