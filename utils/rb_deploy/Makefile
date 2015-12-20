.DEFAULT:all

all: env
	@echo "in all"
.PHONY:all

env: lib/net/ssh lib/net/scp lib/kazoo

lib/net/ssh:
	test -f net-ssh-2.9.1.zip || wget --no-check-certificate https://github.com/net-ssh/net-ssh/archive/v2.9.1.zip -O net-ssh-2.9.1.zip
	test -d net-ssh-2.9.1 || unzip net-ssh-2.9.1.zip
	rsync -a net-ssh-2.9.1/lib/net lib/

lib/net/scp:
	test -f net-scp-1.2.1.zip || wget --no-check-certificate https://github.com/net-ssh/net-scp/archive/v1.2.1.zip -O net-scp-1.2.1.zip
	test -d net-scp-1.2.1 || unzip net-scp-1.2.1.zip
	rsync -a net-scp-1.2.1/lib/net lib/

lib/kazoo:
	test -f kazoo-2.0.zip || wget https://github.com/python-zk/kazoo/archive/2.0.zip -O kazoo-2.0.zip
	test -d kazoo-2.0 || unzip kazoo-2.0.zip
	cd kazoo-2.0 # && 	make build
	rsync -a kazoo-2.0/kazoo lib/

# lib/zookeeper-master:
# 	test -f zookeeper-master.zip || wget --no-check-certificate https://github.com/zk-ruby/zookeeper/archive/master.zip -O zookeeper-master.zip
# 	test -d zookeeper-master || unzip zookeeper-master.zip
# 	rsync -a zookeeper-master/lib/zookeeper* lib/

# lib/rubygems:
# 	test -f rubygems-master.zip || wget --no-check-certificate https://github.com/rubygems/rubygems/archive/master.zip -O rubygems-master.zip
# 	test -d rubygems-master || unzip rubygems-master.zip
# 	rsync -a rubygems-master/lib/rubygems* lib/
