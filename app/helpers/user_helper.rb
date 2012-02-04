module UserHelper
  def user_description(user)
    if user.description.nil? or user.description.empty? 
      t :no_description
    else
      user.description
    end
  end

  def user_entry_count(user)
    return user.entrys.count if user == current_user 
    cnt = 0
    user.entrys.each do |entry|
      cnt += 1 if entry.completed?
    end
    cnt
  end

  def user_follower_desc(user)
    if user == current_user 
      t :self_follower
    else
      t :other_follower
    end
  end

  def user_following_desc(user)
    if user == current_user 
      t :self_following
    else
      t :other_following
    end
  end
end

