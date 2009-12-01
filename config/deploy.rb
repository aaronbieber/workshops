set :application, "workshops"
set :repository, "git://github.com/aaronbieber/workshops.git"

task :new do
	set :domain, "diagramwar.com"
	set :deploy_to, "/var/www/artphotoworkshops.com/workshops"
end

task :current do
	set :domain, "artphotoworkshops.com"
	set :deploy_to, "/var/www/artphotoworkshops.com/workshops"
end
