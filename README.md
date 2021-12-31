# dst-dedicated-server-scripts
A collection of scripts to run and manage Don't Starve Together dedicated servers

## Quick start guide
Clone the repo to your system. All directories in these instructions will be in the users home directory. 

```
git clone https://github.com/suppaduppax/dst-dedicated-server-scripts
```

Now go into that directory

```
cd dst-dedicated-server-scripts
```

First thing that needs to be done is the `settings.conf` file needs to be created. 
Copy the settings.conf.template file as a starting point

```
cp settings.conf.template settings.conf
```

Edit the settings to match your environment. For this example we will be using nano but use whichever editor you want to.

```
nano settings.conf
```

Here is an example of a working settings file:

```/home/user/dst-dedicated-server-scripts/settings.conf```

```
# Do not put anything in quotes
# Do not put any spaces before or after the equals sign
# See http://github.com/suppaduppax/dst-dedicated-server-scripts/ for details

klei_dst_path=/home/user/.klei/DoNotStarveTogether
steamcmd_path=/home/user/steamcmd
dst_bin_path=/home/user/steam/steamapps/common/Don't Starve Together Dedicated Server/bin
discord_webhook=https://discord.com/api/webhooks/ajnddkdibneoekdbbdkeinrmpdojmekediod111dmmwosodb32beoejapqkenn1

# delay the shutdown and announce a warning when a new update is detected (in minutes)
update_shutdown_delay=15
update_shutdown_warning=5

# other settings
log_enabled=true
log_file=dst.log
log_file_max_lines=500
release_file=current-server-version.txt
builds_url=https://s3.amazonaws.com/dstbuilds/builds.json
```

---
|Variable|Description
|---|---
| klei_dst_path | The path to the actual server files. Usually found in `~/.klei/DoNotStarveTogether`
| steamcmd_path | The path to the steamcmd file. 
| dst_bin_path | The path to the DST bin directory. By default should be inside the steamcmd folder `<steamcmd_path>/steamapps/common/Don't Starve Together/bin`
| discord_webhook | If you want to have discord notifications fill this in. To disable, leave blank `discord_webhook=`

The other settings are more or less optional so we will skip them for now. 

