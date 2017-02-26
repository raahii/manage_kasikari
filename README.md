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

1. clone repostitory
	
	```
	git clone <this_repository>
	cd manage_kasikari
	bundle install
	```

2. install and start mysql

	```
	brew install mysql
	mysql.start
	```

3. set up mysql

	```
	mysql -u root

	mysql> update mysql.user set password=password('root用の好きなパスワード') where user = 'root';
	mysql> flush privileges;
	mysql> exit;
	```
	
	そしたら環境変数にrootのパスワードを書く。~/.bashrcとか~/.bash_profileとか適当に以下を追記。
	
	```
	export DB_ROOT_PASSWORD=さっき設定したパスワード
	```
	
	最後にターミナルを再起動
	
	
4. migration

	```
	bundle exec rake db:migrate
	```
	
	問題なく動けばLGTM！！

## Memo

```
rails new --skip-spring --skip-turbolinks --skip-test --database mysql manage_kasikari

bundle install

bundle exec rake db:create
```
