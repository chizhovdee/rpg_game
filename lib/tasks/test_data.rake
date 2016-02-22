namespace :app do
  namespace :characters do
    desc "Create new test character"
    task :create_test => :environment do
      Character.new.tap do |c|
        c.energy = c.ep = 10
        c.health = c.hp = 100
        c.basic_money = 10
        c.vip_money = 3
        c.ep_updated_at = c.hp_updated_at = Time.zone.now
      end.save!
    end
  end
end