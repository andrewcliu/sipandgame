class SitemapsController < ApplicationController
  def index
    @pages = [ root_url, boba_tea_menu_url, all_about_sip_url, gallery_url ]
  end
end
