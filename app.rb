require 'sinatra'
require 'sinatra/activerecord'
require 'json'

# Database configuration
configure :development do
  set :database, {
    adapter: 'postgresql',
    encoding: 'unicode',
    database: 'task_list_dev',
    pool: 5,
    username: 'postgres',
    password: 'password',
    host: '13.60.61.143',
    port: 5432
  }
end

# Task model
class Task < ActiveRecord::Base
end

# Before block to set content type
before do
  content_type 'application/json'
end

# GET all tasks
get '/tasks' do
  tasks = Task.all
  tasks.to_json
end

# GET a specific task by ID
get '/tasks/:id' do
  task = Task.find_by(id: params[:id])
  if task
    task.to_json
  else
    status 404
    { error: 'Task not found' }.to_json
  end
end

# POST a new task
post '/tasks' do
  request.body.rewind
  task_params = JSON.parse(request.body.read)
  task = Task.create(title: task_params['title'], description: task_params['description'])
  status 201
  task.to_json
end

# PUT/UPDATE a task by ID
put '/tasks/:id' do
  task = Task.find_by(id: params[:id])
  if task
    request.body.rewind
    task_params = JSON.parse(request.body.read)
    task.update(title: task_params['title'], description: task_params['description'])
    task.to_json
  else
    status 404
    { error: 'Task not found' }.to_json
  end
end

# DELETE a task by ID
delete '/tasks/:id' do
  task = Task.find_by(id: params[:id])
  if task
    task.destroy
    status 204
  else
    status 404
    { error: 'Task not found' }.to_json
  end
end

