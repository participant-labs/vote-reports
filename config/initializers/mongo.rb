require 'mongo_mapper'

config = YAML.load_file(Rails.root.join('config', 'mongo.yml'))
MongoMapper.setup(config, Rails.env, {
  :logger    => Rails.logger,
  passenger: true,
})
MongoMapper.database = config[Rails.env]['database']
