#! /bin/bash
#
# Write a script to backup data in ~/.ssh and ~/.zshrc.private
# Copy data to backup folder, zip them and remove the temp folder

# Create backup folder with datetime, hostname and username
backup_folder=~/backup/$(date +%Y%m%d_%H%M%S)_$(hostname)_$(whoami)
mkdir -p $backup_folder

# Copy data to backup folder
cp -r ~/.ssh $backup_folder
cp ~/.zshrc.private $backup_folder

# Zip backup folder
zip -r $backup_folder.zip $backup_folder

# Remove temp folder
rm -rf $backup_folder

# End of script
