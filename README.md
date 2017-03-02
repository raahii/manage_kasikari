# MKK（Manage Kasi Kari）

## 開発環境

・Ruby on Rails

・HTML

・CSS

## 概要

友人間での貸し借りを円滑に進めます

例えば…

あなたが友人に貸した本など返って来なかったこと

あなたが友人に借りたゲームソフトなど返すのを忘れて気まずくなったこと

etc…

こんな問題を解決するために生まれたアプリケーション！！



## 使い方


## セットアップ

1. リポジトリをクローン

  ```
  git clone <this_repository>
  cd manage_kasikari
  bundle install
  ```

  OS X Sierraで`bundle install`が失敗する場合は[ココ](http://nekonenene.hatenablog.com/entry/2016/10/31/061350)を参考。

2. mysqlのインストール

  ```
  brew update && brew upgrade
  brew install mysql
  mysql.start
  ```

3. mysqlのセットアップ

  ```
  mysql -u root

  mysql> update mysql.user set password=password('root用の好きなパスワード') where user = 'root';
  mysql> flush privileges;
  mysql> exit;
  ```
  もし上記で
  ```
  ERROR 1054 (42S22): Unknown column 'password' in 'field list'
  ```
  のようなエラーでひっかかった場合には
  ```
  mysql> update mysql.user set authentication_string=password('root用の好きなパスワード') where user = 'root';
  ```
  を試す。

  そしたら環境変数にrootのパスワードを書く。~/.bashrcとか~/.bash_profileとか適当に以下を追記。

  ```
  export DB_ROOT_PASSWORD=さっき設定したパスワード
  ```

  最後にターミナルを再起動


4. migration

  ```
  bundle exec rake db:create
  bundle exec rake db:migrate
  ```

  問題なく動けばLGTM！！

## Memo

```
rails new --skip-spring --skip-turbolinks --skip-test --database mysql manage_kasikari

bundle install

bundle exec rake db:create
```
