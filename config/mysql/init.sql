-- Create the missing databases if they don't exist
CREATE DATABASE IF NOT EXISTS secure_2fa_cache_production;
CREATE DATABASE IF NOT EXISTS secure_2fa_queue_production;
CREATE DATABASE IF NOT EXISTS secure_2fa_cable_production;

-- Check current user privileges
SHOW GRANTS FOR 'secure_2fa'@'%';

-- Grant all privileges on the new databases
GRANT ALL PRIVILEGES ON secure_2fa_cache_production.* TO 'secure_2fa'@'%';
GRANT ALL PRIVILEGES ON secure_2fa_queue_production.* TO 'secure_2fa'@'%';
GRANT ALL PRIVILEGES ON secure_2fa_cable_production.* TO 'secure_2fa'@'%';

-- Make sure the main database is also accessible
GRANT ALL PRIVILEGES ON secure_2fa_production.* TO 'secure_2fa'@'%';

-- Apply the changes
FLUSH PRIVILEGES;

-- Verify the grants were applied
SHOW GRANTS FOR 'secure_2fa'@'%';
