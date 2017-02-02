$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'url_shortener'

app = URLShortener::Application.new
run app
