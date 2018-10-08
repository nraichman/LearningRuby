class ApplicationController < ActionController::Base
    def hello
        render html: "Hola, Mondu!"
    end
end
