# Podman for Windows

Installing and using podman with Powershell and Ubuntu on WSL2 

## Install WSL 

Use the Microsoft Store to install Ubuntu 20.04 LTS

From Start menu launch Ubuntu 

Create a user and password when prompted

## Install podman 

Download provided `podman-install.sh` and `podman-service` files.

Edit `podman-instal.sh` to set your path

Copy `podman-instal.sh` and `podman-service` form windows to WSL machine. Adapt the path for your case.

```bash
sudo cp /mnt/c/Users/Jhon/Desktop/podman.sh ~/podman.sh
sudo cp /mnt/c/Users/Jhon/Desktop/podman-service.conf ~/podman-service.conf
```

Make script runnable 

```bash
sudo chmod +x ~/podman.sh
```

run the script as root 

```bash
sudo ~/podman.sh
```

## Configure Powershell

Donwload latest 3.X.X .msi release from Github and install it

https://github.com/containers/podman/releases?page=1

Replace you linux username and run in powershell 

```powershell
$LINUX_USER="jhonm"
podman system connection add wsl --identity $HOME\.ssh\id_rsa_localhost ssh://$LINUX_USER@localhost/run/user/2000/podman/podman.sock
```

Check the installation 

```powershell
podman run --rm -it hello-world
```

## Sources

[Podman](https://github.com/containers/podman)
[Installing podman on Windows](https://www.devcon5.ch/en/blog/2021/10/14/podman-for-windows/)


