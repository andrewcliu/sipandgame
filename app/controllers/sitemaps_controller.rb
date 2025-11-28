class SitemapsController < ApplicationController
  def index
    @pages = [root_url, menu_url]
  end
end