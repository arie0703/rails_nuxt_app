CarrierWave.configure do |config|
    config.asset_host = 'http://localhost:3000'
    config.storage = :file
end