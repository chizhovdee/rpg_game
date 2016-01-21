create TABLE characters (
  id serial primary key,
  level integer not null default 1,
  energy integer not null default 0,
  ep integer not null default 0,
  health integer not null default 0,
  hp integer not null default 0,
  experience integer not null default 0,
  points integer not null default 0,
  basic_money integer not null default 0,
  vip_money integer not null default 0,
  ep_updated_at timestamptz not null DEFAULT CURRENT_TIMESTAMP,
  hp_updated_at timestamptz not null DEFAULT CURRENT_TIMESTAMP,
  created_at timestamptz not null DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamptz not null DEFAULT CURRENT_TIMESTAMP
);


create TABLE character_states (
  character_id integer references characters(id),
  quests jsonb
);


create or replace FUNCTION insert_character_state_func()
RETURNS trigger AS $first_trigger$
begin
  insert into character_states (character_id) values (new.id);
  return new;
end;
$first_trigger$ language plpgsql;


create TRIGGER insert_character_state after insert on characters
for each row
execute procedure insert_character_state_func();
