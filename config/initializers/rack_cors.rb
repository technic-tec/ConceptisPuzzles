Rails.application.config.middleware.use Rack::Cors, :debug => true, :logger => (-> { Rails.logger }) do
  allow do
    origins 'localhost'
    resource '/cors',
      :headers => :any,
      :methods => [:get],
      :credentials => true,
      :max_age => 0
  end
end
