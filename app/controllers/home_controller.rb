class HomeController < ApplicationController
  def index
    @title = t "title.home"
    if user_signed_in? 
      redirect_to user_path(current_user)
    else
      @posts = MicroPost.paginate(:page => params[:page], :per_page => 5)
    end
  end

  def about
    @title = t "title.about"
  end

  def intro
    @full_title = t "title.site"
    if user_signed_in? 
      redirect_to user_path(current_user)
    end
  end

  def story
    @title = t "title.about"
  end

  def update_log
    @title = t "title.update_log"
  end

  def suggest
    @title = t "title.suggest"
  end

  def stat
  end
end
