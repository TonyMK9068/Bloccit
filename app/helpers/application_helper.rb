#You can write methods in the ApplicationHelper that can be used across your application. 
#It's actually a Module (remember the Classes checkpoint?) that Rails includes with other classes in your app. 
#Basically, any public method you write in ApplicationHelper will be available anywhere.


module ApplicationHelper
  def control_group_tag(errors, &block)
    if errors.any?
      content_tag :div, capture(&block), class: 'control-group error'
    else
      content_tag :div, capture(&block), class: 'control-group'
    end
  end
end
