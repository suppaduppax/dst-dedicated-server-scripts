# dst-dedicated-server-scripts
A collection of scripts to run and manage Don't Starve Together dedicated servers

## Quick start guide
### Prerequisites ###
- The steam must already be installed in your system. Go to https://developer.valvesoftware.com/wiki/SteamCMD for instructions (the QuickStart used the manual installation into the user home directory)
- A server along with a token must already be extracted to the klei dst directory. Go to https://accounts.klei.com/login to create your server template and token. 

This guide does not cover these two steps and assumes it has already been done. 

### Installation and Setup ###
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

### (Optional) Add scripts bin to user PATH environment ###
If you want to be able to run the scripts from anywhere, add this line in your `~/.bashrc` file:
```
export PATH="$HOME/dst-dedicated-server-scripts/bin:$PATH"
```
Make sure to replace `$HOME/` with the correct path. 

