# jsonで返す内容を作る

json.cards @cards do |card| #一覧取得
    json.extract! card, :id, :title, :detail, :goal, :created_at, :user_id
end

json.challenges @challenges do |challenge| #一覧取得
    json.extract! challenge, :id, :title, :detail, :continuation, :goal, :cleared, :is_started, :is_done, :start_date, :end_date, :created_at, :user_id
end

json.user do
    json.extract! @user
end

json.card do #詳細画面
    json.extract! @card
end
