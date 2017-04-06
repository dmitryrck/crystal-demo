# crystal_demo

TODO: Write a description here

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Database

This project uses [IMDB database](http://www.imdb.com/interfaces). It does not
import from list files.

To import IMDB database we recommend [IMDbPy](http://imdbpy.sourceforge.net/).

*Warning*: This software and the authors have no rights to give you any
permission to use IMDB data.

## Development

To run:

    % DATABASE_URL=postgres://postgres@localhost:5432/imdb crystal ./src/crystal_demo.cr

## Production

Build an optimized release with:

    % crystal build --release ./src/crystal_demo.cr -o bin/app

Copy the binary to server and run your app:

    % DATABASE_URL=postgres://postgres@localhost:5432/imdb ./app

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
