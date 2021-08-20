json.posts @cards do |card|
    json.extract! card, :id, :title, :detail, :is_started, :is_done, :created_at
end