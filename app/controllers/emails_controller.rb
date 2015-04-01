class EmailsController < ApplicationController
  def index
    @emails = Email.all.order('deliver_at asc')
  end

  def new
  end
end
