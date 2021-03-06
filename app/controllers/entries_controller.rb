class EntriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @entries = current_user.all_entries
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @entry = Entry.find(params[:id])
    data = {}
    data[:id] = @entry.id
    if @entry.completed?
      data[:entry] = render_to_string :partial => 'entries/entry'
      data[:complete] = "success"
    elsif @entry.failed?
      data[:complete] = "failed"
      data[:err_msg] = render_to_string :partial => "entries/status"
    else
      data[:complete] = "wait"
    end
    respond_to do |format|
      format.js { render :json => data.to_json, :content_type => 'application/json' }
    end
  end

  def retry
    @entry = Entry.find(params[:id])
    @entry.try_complete unless @entry.completed?
    redirect_to @entry.user
  end

  def new
    @entry = Entry.new
    @title = t "title.add_manual_entry"
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def new_blog
    @entry = Entry.new
    @title = t "title.add_blog_entry"
  end

  def new_github
    @entry = Entry.new
    @title = t "title.add_github_entry"
  end

  def new_auto
    @entry = Entry.new
    @title = t "title.add_auto_entry"
  end

  def edit
    @entry = Entry.find(params[:id])
    @title = t "title.edit_entry"
  end

  def create
    @entry = Entry.create(params[:entry], current_user)
    @entry.try_complete
    respond_to do |format|
      if @entry.save
        format.html { redirect_to user_path(current_user), notice: 'add done' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @entry = Entry.find(params[:id])
    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        format.html { redirect_to edit_entry_path(@entry), notice: 'Entry was successfully updated.' }
      else
        flash.now[:alert] = "update entry failed"
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to current_user }
    end
  end
end
