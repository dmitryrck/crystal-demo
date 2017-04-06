-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
create table title(
  id serial primary key,
  title text not null,
  imdb_index character varying(12),
  kind_id integer not null,
  production_year integer,
  imdb_id integer,
  phonetic_code character varying(5),
  episode_of_id integer,
  season_nr integer,
  episode_nr integer,
  series_years character varying(49),
  md5sum character varying(32),
  created_at timestamp,
  updated_at timestamp
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back

drop table title;
