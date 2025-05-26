# Test mTCP

### Packages to install

```
apt install bc libgmp3-dev autotools-dev build-essential librdmacm-dev libnuma-dev libmnl-dev
```

### How to compile/make mTCP

1. Download mTCP (as root)

```
sudo su -
git clone https://github.com/mtcp-stack/mtcp
cd mtcp
git submodule init
git submodule update
```



2. Compile mTCP

```
./setup_mtcp_dpdk_env.sh
option 15
option 18
option 22 Type 64
option 24 Type 0000:00:08.0
option 35
```

3. Run setup scripts

On the setup on each respective VM

```
./setup-vm{1,2}.sh
```


3. Setup nics



 - On Both

```
./configure --with-dpdk-lib=$RTE_SDK/$RTE_TARGET CFLAGS="-DMAX_CPUS=1"
make
```
