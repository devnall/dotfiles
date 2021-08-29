# Vagrant Cheat Sheet

## Main commands
* `vagrant init` - Initialize a new Vagrant project
* `vagrant status` - Show status of Vagrant(s) inside current directory
* `vagrant global-status` - Show status of all Vagrants on the host machine
* `vagrant package` - Package the vagrant into a box image (can be running or halted)
* `vagrant box` - Manage Vagrant boxes

### vagrant box
* `vagrant box add NAME ADDRESS` - Add a box to the box list. NAME is the friendly name you want to give the box, ADDRESS is the path to the .box file
* `vagrant box remove NAME --provider PROVIDER --box-version VERSION`
* `vagrant box repackage NAME PROVIDER VERSION`

### vagrant global-status
* `vagrant global-status --prune` - Clean up global-status output

### vagrant package
* `vagrant package --output box-name.box` - Specify output name of newly-created box

## HOWTOs

### Creating a new Vagrant environment
Prerequeites:
$PROJECT_HOME = directory of Vagrant project
$BOX = box to use for Vagrant project, e.g. ubuntu/trusty64, ubuntu/precise32, see atlas.hashicorp.com for more
1. `mkdir -p $PROJECT_HOME && cd $PROJECT_HOME && vagrant init -m $BOX`
2. `vagrant ssh` and setup the environment to the state you want the Vagrant image to be in
3. `vagrant package --ouput box-name.box`
