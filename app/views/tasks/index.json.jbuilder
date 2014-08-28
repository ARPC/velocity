json.array!(@tasks) do |task|
  json.extract! task, :id, :fog_bugz_id, :title, :estimate, :lane, :status, :shepherd, :board, :comments
  json.url task_url(task, format: :json)
end
