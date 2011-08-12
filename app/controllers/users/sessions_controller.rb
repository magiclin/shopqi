#encoding: utf-8
class Users::SessionsController < Devise::SessionsController
  before_filter :get_host, only: :create
  before_filter :force_domain # 登录信息需要用到https，必须重定向至 .myshopqi.com

  private
  def get_host # 设置的域名参数在 User.find_for_database_authentication 中使用
    params[:user][:host] = request.host
  end

  def force_domain # ApplicationController.force_domain()要保持一致
    myshopqi = Shop.at(request.host).domains.myshopqi
    redirect_to "#{request.protocol}#{myshopqi.host}#{request.port_string}#{request.path}" if request.host != myshopqi.host
  end
end