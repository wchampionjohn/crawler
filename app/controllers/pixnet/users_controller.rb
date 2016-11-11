class Pixnet::UsersController < ApplicationController
  def index
    @users = Pixnet::User.all
  end
end
