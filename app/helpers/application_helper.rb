module ApplicationHelper
  def default_meta_tags
    {
      site: 'サブスクアニメ時間割',
      title: 'サブスクアニメ時間割',
      reverse: true,
      charset: 'utf-8',
      description: 'Amazon、Abema、Netflixの今期アニメを時間割形式で管理。アニメの最新話をLINEで通知します。',
      keywords: '今期アニメ,スケジュール,サブスク,Amazonプライム,ABEMA,Netflix',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('icon.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: 'サブスクアニメ時間割',
        title: 'サブスクアニメ時間割',
        description: 'Amazon、Abema、Netflixの今期アニメを時間割形式で管理。アニメの最新話をLINEで通知します。',
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@y_waic',
      }
    }
  end
end
