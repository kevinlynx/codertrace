module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.downcase, :alt => user.name, :class => 'gravatar',
                       :gravatar => options)
  end

  def link_to_submit(text, options = {})
    link_to_function text, "$(this).closest('form').submit()", options
  end

  def title
    if @full_title.nil?
      if @title.nil?
        'Coder Trace'
      else
        @title + ' - Coder Trace'
      end
    else
      @full_title
    end
  end
end
