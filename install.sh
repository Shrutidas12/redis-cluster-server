#!/bin/bash 


sudo apt-get update 
sudo apt install make gcc libc6-dev tcl -y
wget http://download.redis.io/releases/redis-stable.tar.gz
tar -xzvf redis-stable.tar.gz
cd redis-stable
make




Server	Master	Slave
1	    6379	6381
2    	6380	6379
3	    6381	6380

server1 = 20.0.1.62
server2 = 20.0.1.136
server3 = 20.0.1.33


redis-stable/src/redis-trib.rb create ip.of.server1:6379 ip.of.server2:6380 ip.of.server3:6381
redis-stable/src/redis-trib.rb create 20.0.1.62:6379 20.0.1.136:6380 20.0.1.33:6381

cd redis-stable/src/
./redis-cli  --cluster create ip.of.server1:6379 ip.of.server2:6380 ip.of.server3:6381

cd redis-stable/src/
./redis-cli  --cluster create 20.0.1.62:6379 20.0.1.136:6380 20.0.1.33:6381

redis-cli -c -h ip.of.server1 -p 6379
ip.of.server1>CLUSTER NODES

redis-cli -c -h 20.0.1.62 -p 6379
20.0.1.62:6379>CLUSTER NODES

./redis-trib.rb add-node --slave --master-id [master_id_c] ip.of.server1:6381 ip.of.server3:6381
./redis-trib.rb add-node --slave --master-id [master_id_a] ip.of.server2:6379 ip.of.server1:6379
./redis-trib.rb add-node --slave --master-id [master_id_b] ip.of.server3:6380 ip.of.server2:6380
redis-cli --cluster add-node ip.of.server1:6381 ip.of.server3:6381 --cluster-slave --cluster-master-id [master_id_c]
redis-cli --cluster add-node ip.of.server2:6379 ip.of.server1:6379 --cluster-slave --cluster-master-id [master_id_a]
redis-cli --cluster add-node ip.of.server3:6380 ip.of.server2:6380 --cluster-slave --cluster-master-id [master_id_b]

redis-cli --cluster add-node 20.0.1.62:6381 20.0.1.33:6381 --cluster-slave --cluster-master-id 3c7a936d7be3d037253217254af4024e9e0d7d31

root@ip-20-0-1-62:~# redis-cli -c -h 20.0.1.62 -p 6379
20.0.1.62:6379> cluster nodes
26e940788add8ad233e7c1f19f4b06faeca8120a 20.0.1.62:6379@16379 myself,master - 0 1586619084000 1 connected 0-5460
43faafe819d83d848145076160b5d9cac3454f1e 20.0.1.33:6380@16380 slave fd9a31032c1201994bc7ef4135701b4098f07343 0 1586619083000 2 connected
1da5331741306207e553c93de77baa2623eaaee7 20.0.1.136:6379@16379 slave 26e940788add8ad233e7c1f19f4b06faeca8120a 0 1586619085000 1 connected
fd9a31032c1201994bc7ef4135701b4098f07343 20.0.1.136:6380@16380 master - 0 1586619083907 2 connected 5461-10922
3c7a936d7be3d037253217254af4024e9e0d7d31 20.0.1.33:6381@16381 master - 0 1586619085911 3 connected 10923-16383
b76b7a7da7df953198c728f785d3bfa6089f1564 20.0.1.62:6381@16381 slave 3c7a936d7be3d037253217254af4024e9e0d7d31 0 1586619082903 3 connected
20.0.1.62:6379>