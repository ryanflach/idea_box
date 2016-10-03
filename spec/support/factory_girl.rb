RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean_with(:truncation)

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
