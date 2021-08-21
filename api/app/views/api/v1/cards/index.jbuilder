# jsonで返す内容を作る

json.cards @cards do |card| #一覧取得
    json.extract! card, :id, :title, :detail, :is_started, :is_done, :created_at
end

json.card do #詳細画面
    json.extract! @card
end
