# アプリ名：サブスクアニメ時間割
> ▼画像をクリックするとアプリ説明の1分動画（Youtube）に遷移します

[![](https://img.youtube.com/vi/Ip7KysRyO40/0.jpg)](https://www.youtube.com/watch?v=Ip7KysRyO40)

【公開URL】https://subani.net/

# サービス概要

複数のサブスク動画配信サービス（VOD）で
アニメの最新話探しに手間取っている人に  
視聴リストの管理と最新話の通知機能を提供する  
アニメ好きのための時間割型コンテンツ管理アプリです。

# メインのターゲットユーザー

* 複数のVODで5作品以上の今期アニメを視聴している
* VODではアニメをメインに視聴している
* 普段は忙しく、時間を制限しながら使いたい

# ユーザーが抱える課題

* どのアニメを何話まで観たか覚えてない
* 再生ページになかなかたどり着かない
* 最新話の更新日が分からず、何度もサイトを開いてしまう

# 解決方法

* 時間割表形式で、作品リスト、視聴曜日、再生ページのリンク、最新話の更新を一覧化する。 
* 視聴中のアニメの最新話が更新されたら、LINEで通知する。

# 機能一覧

【ユーザー】

**1. ログイン/ログアウト機能**
* 登録不要のゲストログイン
* LINEログイン（メールアドレスとパスワードを自動生成し、登録者のline_uidをuidカラムに保存）
* メールアドレスとパスワードによるログイン

**2. アニメタイトル登録、編集**
* Amazon、Abema、Netflixで配信中のアニメタイトルをチェックボックス形式で選択して一括登録
* タイトル、再生URL、配信メディア、配信曜日をリスト形式で一覧化
* LINE通知オン/オフの切り替え
* タイトルリストからの削除

**3. 時間割形式のマイリスト**
* アニメタイトル登録と同時に、配信曜日と同じ曜日に時間割カードを自動追加
* 時間割カードをクリックすると、アニメの再生ページに遷移
* 時間割カード右上のアイコンから時間割の登録曜日の変更、カードの削除
* 最新話がアップされると最新話フラグがオン、時間割カード下部に「New!○話」と表示。チェックをつけるとフラグオフ、Newマークが消える

**4. LINE通知機能**
* 自動スクレイピングにより、毎朝6時半にアニメの最新話の更新を再生URL付きでLINE通知
* タイトル一覧ページでLINE通知をオンにし、LINE公式アカウントを友達追加後、LINEログインもしくはアカウント連携を行うことで通知が開始される
* LINEログインもしくは連携後に、リッチメニューで「ログイン」を選択すると、メニューが切り替わる

**4-1. LINE公式アカウント： ログイン前リッチメニュー**
* 「アカウント登録」→Web版のユーザー登録ページに遷移
* 「アカウント連携」→メール登録中のユーザーに連携用ログインURLを送信し、ログイン成功後LINEのuidをUserテーブルに保存
* 「ログイン」→Userテーブル内に操作ユーザーのuidがあれば（連携済みの状態）、ログイン後リッチメニューに切り替わる

**4-2. LINE公式アカウント： ログイン後リッチメニュー**
* 「登録タイトル一覧」→Web版のタイトル一覧ページに遷移し、登録タイトルの編集やLINE通知オン/オフの切り替えを行う
* 「時間割表」→Web版の時間割表ページに遷移
* 「今日のアニメ」→時間割登録中かつ配信曜日が当日のアニメリストを通知
* 「未視聴アニメ」→時間割登録中かつ最新話フラグがオンのアニメリストを通知
* 「ログアウト」→ログイン前リッチメニューに切り替え
* 「連携解除」→LINEのアカウント連携を解除（メール登録の場合：uidを削除、LINEログインの場合：アカウント削除）

【管理者】
* 登録ユーザー、管理ユーザーのCRUD
* 管理画面ログイン
* 今季アニメのリスト管理（タイトル、再生ページURL、配信媒体、配信曜日、話数、配信時期）
* 最新話の更新をチェックする自動スクレイピング（Selenium、rake_task、whenever）
* AWS S3にローカルDBをCSVファイル化して自動アップロード（rake_task、whenever）
* LINEのアカウント連携、リッチメニューの切り替え

# なぜこのサービスを作ったのか？
### 【個人的な問題を解決するため】  

自分自身が今一番ほしいサービスだからです。\
プログラミング学習の息抜きにVODでアニメを観ていて、\
ついアマプラなどを開いてしまい、時間を浪費してしまう問題を抱えています。
  
１シーズンで5タイトル以上を観ているため、\
どのサイトで何曜日に最新話が更新されるのかを憶えておらず、\
何度も再生ページを見にいってしまってます。

#### 「メモ帳に書いておけば済む話では？」
一覧性が低く、タイトルやURLを追記するのが手間です。\
また、どこに書いたか忘れがちだったりします。

#### 「VODのマイリスト機能を使えばいいのでは？」
コンテンツ一覧ページを経由する必要があり\
他の作品に目移りして時間を浪費してしまうため、\
公式はあまり開きたくないです。

### 【サブスクと上手に付き合うため】  
現代は手軽に大量のコンテンツを消費できる時代です。\
昔はテレビで録画したりレンタルビデオを借りたりする労力がありましたが、\
VODに登録すれば1話から最終回まで簡単に一気見できてしまう。\
個人的には非常に依存性の高いサービスだと感じています。

一方で、クリエイターが心血を注いで作った素晴らしい作品を\
より多くの人に見てほしいし、応援したい気持ちもあります。

サブスクコンテンツと程よい距離感を保ち、\
やるべきことにより多くの時間を投下できるように、\
このアプリを使っていただきたいです。

# 使用技術
### 主なgem
* `devise` :ログイン
* `rails_admin` :管理画面
* `whenever` :cronの実行
* `omniauth-line` :LINEログイン
* `line-bot-api` :LINEプッシュ通知
* `selenium-webdriver` :スクレイピング
* `aws-sdk-s3` :ローカルDBとHerokuDBをCSVで中継
* `acts_as_list` :時間割の並び替え
* `counter_culture` :LINEプッシュ通知のカウント

### フロントエンド
* Bootstrap 4.3.1
* jquery-rails

### バックエンド
* Ruby 2.6.6
* Rails 5.2.6
* Rspec

### インフラストラクチャー
* PostgreSQL 13.5
* Heroku
* AWS　S3

# ER図
![subani_erd](https://user-images.githubusercontent.com/65857152/149251133-a6ab0608-598e-47f1-9604-c6ae5a906b04.png)
