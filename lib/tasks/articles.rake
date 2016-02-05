namespace :articles do
  desc '新しい記事入稿'
  task new_post: :environment do
    Animation.update_article
    begin
      # グラビア関係の記事を追加
      Article.new_post('idol')
    rescue
    end

    begin
      # メイド関係の記事を追加（下書きで）
      # Article.new_post('maid', nil, false, 'maid')
    rescue
    end

  end

  task reset_data: :environment do
    Article.destroy_all
  end
end
