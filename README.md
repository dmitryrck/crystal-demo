# CrystalDemo

TODO: Write a description here

## Installation

TODO: Write installation instructions here

## Database

This project uses [IMDB database](http://www.imdb.com/interfaces). It does not
import from list files.

To import IMDB database we recommend [IMDbPy](http://imdbpy.sourceforge.net/).

*Warning*: This software and the authors have no rights to give you any
permission to use IMDB data.

## Usage

In order not to change the schema of the database the auth is managed by the
table `name` using just `id` and `md5sum` to match a user.

This way if you are importing the list files from IMDB you already have 6064219
users.

Get your user, for example:

    postgres@pgsrv:/$ psql imdb
    psql (9.6.2)
    Type "help" for help.

    imdb=# select id,md5sum from name limit 1;
     id  |              md5sum
    -----+----------------------------------
     719 | cf45e7b42fbc800c61462988ad1156d2
    (1 row)

    imdb=#

Get your token:

    %  curl -i --data "email=719&password=cf45e7b42fbc800c61462988ad1156d2" -X POST "http://localhost:3000/sign_in"
    HTTP/1.1 200 OK
    Connection: keep-alive
    X-Powered-By: Kemal
    Content-Type: text/html
    Content-Length: 166

    {"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6NzE5LCJtZDVzdW0iOiJjZjQ1ZTdiNDJmYmM4MDBjNjE0NjI5ODhhZDExNTZkMiJ9.k-qUCpMA7wR1C17Tw0gI9TZ4HZfXOSOQD0sJbOhY_pw="}

If you use a wrong match of `id` and `md5sum`:

    %  curl -i --data "email=1&password=cf45e7b42fbc800c61462988ad1156d2" -X POST "http://localhost:3000/sign_in"
    HTTP/1.1 403 Forbidden
    Connection: keep-alive
    X-Powered-By: Kemal
    Content-Type: text/html
    Content-Length: 59

    {"error":400,"message":"Your id and md5sum does not match"}

And the next requests:

    %  curl -i -H "X-Token: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6NzE5LCJtZDVzdW0iOiJjZjQ1ZTdiNDJmYmM4MDBjNjE0NjI5ODhhZDExNTZkMiJ9.k-qUCpMA7wR1C17Tw0gI9TZ4HZfXOSOQD0sJbOhY_pw=" "http://localhost:3000/titles?page=100"
    HTTP/1.1 200 OK
    Connection: keep-alive
    X-Powered-By: Kemal
    Content-Type: text/html
    Content-Length: 839

    [{"id":4218231,"title":"Tony Robinson and...","kind_type":{"name":"tv series","id":2}},{"id":4218230,"title":"Wonders of the Universe","kind_type":{"name":"tv series","id":2}},{"id":4218229,"title":"(1955-11-01)","kind_type":{"name":"episode","id":7}},{"id":4218228,"title":"(1954-11-01)","kind_type":{"name":"episode","id":7}},{"id":4218227,"title":"Yagyu bugeicho - Ninjitsu","kind_type":{"name":"movie","id":1}},{"id":4218226,"title":"Why Dunblane?","kind_type":{"name":"episode","id":7}},{"id":4218225,"title":"The Siege of Kontum","kind_type":{"name":"episode","id":7}},{"id":4218224,"title":"The Quiet Mutiny","kind_type":{"name":"episode","id":7}},{"id":4218223,"title":"The Man Who Stole Uganda","kind_type":{"name":"episode","id":7}},{"id":4218222,"title":"The Life and Death of Steve Biko","kind_type":{"name":"episode","id":7}}]

If you don't provide your token:

    %  curl -i "http://localhost:3000/titles?page=100"
    HTTP/1.1 403 Forbidden
    Connection: keep-alive
    X-Powered-By: Kemal
    Content-Type: text/html
    Content-Length: 35

    {"error":403,"message":"Forbidden"}

## List of endpoints

* `POST /sign_in`, params: `email` (required) and `password` (required);
* `GET /current_user`;
* `GET /titles`, params: `page` (optional);

## Development

To run:

    % DATABASE_URL=postgres://postgres@localhost:5432/imdb crystal ./src/crystal_demo.cr

## Production

Build an optimized release with:

    % crystal build --release ./src/crystal_demo.cr -o bin/app

Copy the binary to server and run your app:

    % DATABASE_URL=postgres://postgres@localhost:5432/imdb PORT=80 ./app

## Heroku

Use the following commands to create an app in heroku with Crystal's buildpack:

    % heroku login
    % heroku create --buildpack https://github.com/crystal-lang/heroku-buildpack-crystal.git
    % heroku addons:create heroku-postgresql:hobby-dev
    % git push heroku master

You have to import IMDB database to heroku as well, but if you are just
testing follow the instructions bellow to create a minimal database with
minimal data:

1. Run migrations:

    % DATABASE_URL=postgres://user:pass@ec2-66-66-66-66.compute-1.amazonaws.com:5432/db123kd6i30pac ./bin/migrate up

2. Connect to database to insert initial data:

    % psql "postgres://user:pass@ec2-66-66-66-66.compute-1.amazonaws.com:5432/db123kd6i30pac"
    psql (9.6.1, server 9.6.2)
    SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
    Type "help" for help.

    db522kd6i30pac=> insert into name (name, md5sum) values ('John', 'cf45e7b42fbc800c61462988ad1156d2');
    INSERT 0 1

Now everthing is ready in Heroku.

## Tests

This project uses IMDB database, in order to run the tests you have to migrate
the test database:

    % createdb imdb_test
    % DATABASE_URL=postgres://postgres@localhost:5432/imdb_test ./bin/migrate up

And run the test suite with:

    % DATABASE_URL=postgres://postgres@localhost:5432/imdb_test crystal spec

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [dmitryrck](https://github.com/dmitryrck) Dmitry Rocha - creator, maintainer
