require 'bundler/capistrano'

set :application, "staunchrobots.com"
set :repository,  "git@github.com:staunchRobots/staunchrobots.com.git"
set :deploy_to,   "/srv/www/#{application}"
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :scm, :git
set :user, "www"
server "173.230.129.222", :web, :app, :db, :primary => true

default_run_options[:shell] = '/bin/bash --login'
default_run_options[:pty] = true

set :branch, "master"
set :shared_dirs,     %w(config log pids bundle)
set :normal_symlinks, %w(log)
# Weird symlinks go somewhere else. Weird.
set :weird_symlinks, { 'pids' => 'tmp/pids', 'bundle' => 'vendor/bundle' }
set :latest_release, fetch(:current_path)

namespace :deploy do

  task :restart, roles: :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :default, roles: [:app, :worker], except: { no_release: true } do
    update
    bundle.install
    restart
  end

  task :update_code, roles: [:app, :worker], except: { no_release: true } do
    run "cd #{current_path}; git fetch origin; git reset --hard origin/#{branch}"
  end

  task :setup, roles: [:app, :worker], except: { no_release: true } do
    run "rm -rf #{current_path}"
    setup_dirs
    run "git clone -q #{repository} #{current_path}"
    run "mkdir -p #{current_path}/tmp"
  end

  task :setup_dirs, roles: [:app, :worker], except: { no_release: true } do
    commands = shared_dirs.map do |path|
      "mkdir -p #{shared_path}/#{path}"
    end
    run commands.join(" && ")
  end

  desc "Make all the symlinks in a single run"
  task :create_symlink, roles: [:app, :worker], except: { no_release: true } do
    commands = normal_symlinks.map do |path|
      "rm -rf #{current_path}/#{path} && ln -s #{shared_path}/#{path} #{current_path}/#{path}"
    end

    commands += weird_symlinks.map do |from, to|
      "rm -rf #{current_path}/#{to} && ln -s #{shared_path}/#{from} #{current_path}/#{to}"
    end

    run <<-CMD
      cd #{current_path} && #{commands.join(" && ")}
    CMD
  end

end