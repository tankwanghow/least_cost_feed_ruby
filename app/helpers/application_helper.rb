module ApplicationHelper

  def render_flash
    a = ''
    top = 40
    flash.each do |name, msg|
      a << content_tag(:div, class: "alert alert-dismissable alert-#{name} col-md-offset-2 col-md-6", style: "top: #{top}px;") do
        content_tag(:button, '&times;'.html_safe, class: 'close', data: { dismiss: 'alert' }) +  
        content_tag(:div, content_tag(:strong, msg), id: "flash_#{name}", class: 'center-text') if msg.is_a?(String)
      end
      top = top + 55
    end
    flash.clear
    a.html_safe
  end

end
