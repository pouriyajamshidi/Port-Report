# Linux Port Monitoring

Portmonitor is a Bash script that is used to provide report on clients who connect to your server(s) on a specific port.

It takes a port number and interval (```default is 443 and 60 seconds```) upon running it and stores information about their IP address, country, city, ISP, AS number and the time they were connected in a text file located in /home/PortMonitor/report.txt.


## Usage

```bash
./portmonitor <port> <interval>
```
You can also make it a service (systemd, etc...) to have it run at your system start time.

## Requirements
```jq``` is required to run this script. However, if it is missing from your machine, the script will notify you and installs it.

## Tested on
Ubuntu 16 to 20.

Anyway it should work fine on any machine that is rocking ```ss``` and ```bash``` .

## Contributing
Pull requests are welcome.


## License
[CC0](https://creativecommons.org/licenses/by/3.0/)