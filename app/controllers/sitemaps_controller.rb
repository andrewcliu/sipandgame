class SitemapsController < ApplicationController
  def index
    @pages = [root_url, menu_url, just_win_and_loot_url]
  end
end