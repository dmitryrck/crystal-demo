-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
create table kind_type(
  id serial primary key,
  kind character varying(15) not null
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
drop table kind_type;
