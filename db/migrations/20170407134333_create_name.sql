-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
create table name(
  id serial primary key,
  name text not null,
  imdb_index character varying(12),
  imdb_id integer,
  gender character varying(1),
  name_pcode_cf character varying(5),
  name_pcode_nf character varying(5),
  surname_pcode character varying(5),
  md5sum character varying(32),
  created_at timestamp,
  updated_at timestamp
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
drop table name;
