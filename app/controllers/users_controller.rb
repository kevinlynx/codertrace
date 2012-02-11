class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js, :json

  def show
    @user = User.find(params[:id])
    @title = @user.name
    load_posts @user
  end

  def followers
    @user = User.find(params[:id])
    @title = t "title.follower"
  end

  def following
    @user = User.find(params[:id])
    @title = t "title.following"
  end

  def refresh_posts
    @user = User.find(params[:id])
    job_sum = 0
    @job_id = -1
    if is_current_user? @user
      job_sum = @user.job_count_self_and_following
      @job_id = @user.add_job_progress job_sum
      @user.refresh_self_and_following_posts @job_id
    else
      job_sum = @user.job_count_self
      @job_id = @user.add_job_progress job_sum
      @user.create_post_from_entries @job_id
    end
    load_posts @user
    respond_to do |format|
      format.js
    end
  end

  # get the refresh_posts progress
  def refresh_progress
    @user = User.find(params[:id])
    @job_id = params[:job_id].to_i
    if @job_id < 0
      redirect_to user_path(@user)
    end
    if JobProgress.all_done? @job_id
      @job_id = -1
      generate_posts @user
      load_posts @user
    end
    data = { :progress => @job_id }
    if @job_id < 0
      data[:posts] = render_to_string :partial => 'shared/posts'
      data[:update_at] = render_to_string :partial => 'users/posts_update_time'
    end
    respond_to do |format|
      format.js { render :json => data.to_json, :content_type => 'application/json' }
    end
  end

  def entry
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  private
    def is_current_user?(user)
      return current_user == user if user_signed_in?
      false
    end

    def load_posts(user)
      if is_current_user? user
        @micro_posts = user.feed.paginate(:page => params[:page], :per_page => 5)
      else
        @micro_posts = user.micro_posts.paginate(:page => params[:page], :per_page => 5)
      end
    end

    def generate_posts(user)
      if is_current_user? user
        user.refresh_self_and_following_posts -1
      else
        user.create_post_from_entries -1
      end
    end
end
