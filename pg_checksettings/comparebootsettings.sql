select name, setting, boot_val,reset_val from pg_settings where boot_val <>reset_val or boot_val<>setting;
