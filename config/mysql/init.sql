-- Create additional databases for your Rails app
CREATE DATABASE IF NOT EXISTS secure_2fa_cache_production;
CREATE DATABASE IF NOT EXISTS secure_2fa_queue_production;
CREATE DATABASE IF NOT EXISTS secure_2fa_cable_production;

-- Grant privileges to the secure_2fa user for all databases
GRANT ALL PRIVILEGES ON secure_2fa_cache_production.* TO 'secure_2fa'@'%';
GRANT ALL PRIVILEGES ON secure_2fa_queue_production.* TO 'secure_2fa'@'%';
GRANT ALL PRIVILEGES ON secure_2fa_cable_production.* TO 'secure_2fa'@'%';

-- Flush privileges to ensure they take effect
FLUSH PRIVILEGES;
