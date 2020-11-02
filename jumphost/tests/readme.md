NOTE - read this when setting up workstation to run go unit tests:
https://github.com/tatsushid/go-fastping/issues/25
Most probably you are bit by a kernel change in recent Ubuntus (or maybe even upstream).
You can do a 
sysctl net.ipv4.ping_group_range 
if the response is 1 0 then the UDP variant will not work. 
To enable all users to use that facility you need
sudo sysctl -w net.ipv4.ping_group_range="0 65535"