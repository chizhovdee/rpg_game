class CreateCharacterResources < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.column :social_id, :bigint
      t.index :social_id

      # attributes
      t.integer :level, null: false, default: 1
      t.integer :energy, null: false
      t.integer :ep, null: false
      t.integer :health, null: false
      t.integer :hp, null: false
      t.integer :experience, null: false, default: 0
      t.integer :points, null: false, default: 0
      t.integer :basic_money, null: false
      t.integer :vip_money, null: false

      t.string :session_key
      t.string :session_secret_key

      t.boolean :installed, default: false

      # times
      t.column :ep_updated_at, :timestamptz, null: false
      t.column :hp_updated_at, :timestamptz, null: false
      t.column :last_visited_at, :timestamptz, null: false

      t.column :created_at, :timestamptz, null: false
      t.column :updated_at, :timestamptz, null: false
    end

    create_table :character_states do |t|
      t.references :character, index: true, foreign_key: true
      t.jsonb :quests
      t.column :created_at, :timestamptz, null: false
      t.column :updated_at, :timestamptz, null: false
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL

          create or replace FUNCTION insert_character_state_func()
          RETURNS trigger AS $first_trigger$
          begin
            insert into character_states (character_id, created_at, updated_at) 
                                  values (new.id, now(), now());
            return new;
          end;
          $first_trigger$ language plpgsql;

          create TRIGGER insert_character_state after insert on characters
          for each row
          execute procedure insert_character_state_func();

        SQL
      end
      
      dir.down do
        execute <<-SQL
          DROP TRIGGER IF EXISTS insert_character_state ON characters;
          DROP FUNCTION  IF EXISTS insert_character_state_func();
        SQL
      end  
    end  
  end
end
