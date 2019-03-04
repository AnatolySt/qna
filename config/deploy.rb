# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "qna"
set :repo_url, "git@github.com:AnatolySt/qna.git"

set :deploy_to, "/home/deploy/qna"
set :local_user, 'deploy'

append :linked_files, "config/database.yml", "config/master.key", "config/thinking_sphinx.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "bin", "public/uploads"

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.5.1'

# in case you want to set ruby version from the file:
# set :rbenv_ruby, File.read('.ruby-version').strip

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails sidekiq sidekiqctl}
set :rbenv_roles, :all # default value


namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end