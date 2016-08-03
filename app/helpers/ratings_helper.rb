module RatingsHelper

  def create_reatings(i, last_comment)
    if last_comment.rating == i
      "<input name='star#{last_comment.id}' type='radio'  value=#{i} class='star#{last_comment.id} {half:true}' disabled='disabled' checked='checked' />".html_safe
    else
      "<input name='star#{last_comment.id}' type='radio'  value=#{i} class='star#{last_comment.id} {half:true}' disabled='disabled' />".html_safe
    end
  end

  def get_user_avatar(this_user)
    if !this_user.facebook_image.nil?
      "<img class='media-object' height='50' width='50' src='#{this_user.facebook_image}' alt='...'>".html_safe
    elsif this_user.image.file.nil? == false
      "<img class='media-object' height='50' width='50' src='#{this_user.image_url}' alt='...'>".html_safe
    else
      "<img class='media-object' height='50' width='50' src='http://res.cloudinary.com/dpxmeadjo/image/upload/v1470231876/no_avatar_ay0cbj.jpg' alt='...'>".html_safe
    end
  end
end