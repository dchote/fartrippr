# fartrippr
quick and simple scripts to automate media backup. If you want an all-in-one process check out ARM (https://github.com/automatic-ripping-machine/automatic-ripping-machine).

**Set up repos and install packages**

```bash
sudo apt-get install git
sudo add-apt-repository ppa:heyarje/makemkv-beta

sudo apt update
sudo apt install xpath makemkv-bin makemkv-oss ffmpeg
```

**Install fartrippr**
```bash
cd /opt
sudo git clone https://github.com/dchote/fartrippr.git
cd fartrippr
```


**Automation**
```bash
sudo ln -s /opt/fartrippr/automation/51-automedia.rules /lib/udev/rules.d/
```