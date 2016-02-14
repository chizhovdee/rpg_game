create TABLE users (
  id serial primary key,
  login varchar(255),
  password varchar(255),
  admin boolean default false,
  created_at timestamptz not null DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamptz not null DEFAULT CURRENT_TIMESTAMP
);

create TABLE characters (
  id serial primary key,
  user_id integer references users(id),
  level integer not null default 1,
  energy integer not null default 0,
  ep integer not null default 0,
  health integer not null default 0,
  hp integer not null default 0,
  stamina integer not null default 0,
  sp integer not null default 0,
  experience integer not null default 0,
  points integer not null default 0,
  basic_money integer not null default 0,
  vip_money integer not null default 0,
  ep_updated_at timestamptz not null DEFAULT CURRENT_TIMESTAMP,
  hp_updated_at timestamptz not null DEFAULT CURRENT_TIMESTAMP,
  sp_updated_at timestamptz not null DEFAULT CURRENT_TIMESTAMP,
  created_at timestamptz not null DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamptz not null DEFAULT CURRENT_TIMESTAMP
);

create TABLE character_states (
  user_id integer references users(id),
  quests jsonb
);

create or replace FUNCTION insert_character_state_func()
RETURNS trigger AS $first_trigger$
begin
  insert into character_states (user_id) values (new.user_id);
  return new;
end;
$first_trigger$ language plpgsql;

create TRIGGER insert_character_state after insert on characters
for each row
execute procedure insert_character_state_func();

