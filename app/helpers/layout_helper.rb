# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  
  def experiment_link(experiment)
    if experiment[:type]=="show"
      "http://#{APP_CONFIG['gui_url']}/experiments/#{experiment[:id]}"
    else
      if experiment[:type]=="edit"
        "http://#{APP_CONFIG['gui_url']}/experiments/#{experiment[:id]}/edit"
      else
        "http://#{APP_CONFIG['gui_url']}/experiments/new" 
      end
    end
  end
  
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def opinions_path
    "http://#{APP_CONFIG['opinions_url']}/opinions"
  end
  def experiments_path
    "http://#{APP_CONFIG['gui_url']}/experiments/"
  end
  
  def slas_path
    "http://#{APP_CONFIG['gui_url']}/slas/"
  end
  
  def settings_path
    "http://#{APP_CONFIG['gui_url']}/settings"
  end
  
  def home_path
    "http://#{APP_CONFIG['gui_url']}/"
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end
