class CorsProxy < Rack::Proxy
  def initialize(app, name = "CorsProxy", proxy_path = '/cors')
    @app = app
    @name = name
    @proxy_path = proxy_path
  end

  def call(env)
    # call super if we want to proxy, otherwise just handle regularly via call
    ((proxy?(env) && super) || @app.call(env))
  end

  def proxy?(env)
    # do not alter env here, but return true if you want to proxy for this request.
    env['PATH_INFO'] == @proxy_path
  end

  def rewrite_env(env)
    # change the env here
    Rails.logger.debug "#{@name}: proxy request #{env}"
    super
  end

  def rewrite_response(triplet)
    # alter response here
    Rails.logger.debug "#{@name}: proxy response #{triplet}"
    super
  end
end
