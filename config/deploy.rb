# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'capstone'
set :scm, :git
set :repo_url, 'git@github.com:collaborations/capstone.git'
set :branch, 'master'
set :log_level, :debug
set :keep_releases, 5
# Default value for :pty is false
# set :pty, true

# Files we want symlinking to specific entries in shared.
set :linked_files, %w{config/database.yml config/secrets.yml config/settings.yml}

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# RVM Settings
# deploy.rb or stage file (staging.rb, production.rb or else)
set :rvm_type, :system                     #/usr/local/rvm
set :rvm_ruby_version, '2.2.0'           
# set :rvm_custom_path, '~/.myveryownrvm'  # only needed if not detected

require 'airbrake/capistrano3'
after "deploy:finished", "airbrake:deploy"
