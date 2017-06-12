# jenkins_swarm

Setup
====
* Create an encryption key to use with data bags
```
openssl rand -base64 512 | tr -d '\r\n' > /path/to/encrypted_data_bag_secret
```
* Create encrypted "jenkins" data bag with a "keys" item
```
knife data bag create jenkins keys --secret-file /path/to/encrypted_data_bag_secret
```
* Add keys for the jenkins service user
* Copy the contents of the `/path/to/encrypted_data_bag_secret` file to `/etc/chef/encrypted_data_bag_secret` on the node after bootstrap. This is needed in order to join the node to jenkins without actually providing a password.

Test Kitchen
---
* Create an SSH key if needed for the jenkins user and add it to the encrypted data bag.
```
ssh-keygen -t rsa -b 4096 -C 'fake_deploy_key'
sed ':a;N;$!ba;s/\n/\\n/g' /path/to/fake_deploy_key
<knife command to add to data bag here>
```
* Copy the conetents of the `/path/to/encrypted_data_bag_secret` file into `test/integration/default/encrypted_data_bag_secret`
* Get the encrypted contents of the "jenkins" data bag and place them in `test/integragration/default/data_bags/jenkins/keys.json`
```
knife data bag show jenkins keys -Fj > test/integragration/default/data_bags/jenkins/keys.json
```
* Run `kitchen converge`
