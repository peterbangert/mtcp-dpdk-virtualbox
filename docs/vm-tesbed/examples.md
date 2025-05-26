# Examples

## Perf

### Configure client.c

- Replace lines in client.conf

```
# git diff apps/perf/client.conf
diff --git a/apps/perf/client.conf b/apps/perf/client.conf
index f13a64d..8cb7e0c 100644
--- a/apps/perf/client.conf
+++ b/apps/perf/client.conf
@@ -3,7 +3,7 @@
 # The underlying I/O module you want to use. Please
 # enable only one out of the two.
 #io = psio
-io = dpdk
+io = dpdk0
 
 # No. of cores setting (enabling this option will override
 # the `cpu' config for those applications that accept
@@ -12,19 +12,20 @@ io = dpdk
 # e.g. in case ./epwget is executed with `-N 4', the
 # mtcp core will still invoke 8 mTCP threads if the
 # following line is uncommented.
-#num_cores = 8
+num_cores = 1
 
 # Number of memory channels per processor socket (dpdk-only)
-num_mem_ch = 4
+num_mem_ch = 1
 
 # Used port (please adjust accordingly)
 #------ PSIO ports -------#
 #port = xge0 xge1
 #port = xge
 #------ DPDK ports -------#
-port = 10gp1
+#port = 10gp1
 #port = dpdk0:0
 #port = dpdk0:1
+port = dpdk0
 
 # Enable multi-process support (under development)
 #multiprocess = 0 master
@@ -36,15 +37,15 @@ port = 10gp1
 # cc = cubic
 
 # Receive buffer size of sockets
-rcvbuf = 6291456
-#rcvbuf = 16384
+#rcvbuf = 6291456
+rcvbuf = 16384
 
 # Send buffer size of sockets
 #sndbuf = 2048
 sndbuf = 4194304
 #sndbuf = 41943040
-#sndbuf = 146000
-
+sndbuf = 1460000
+#sndbuf = 3750000
 # Maximum concurrency per core
 max_concurrency = 10000
 
@@ -54,7 +55,7 @@ max_num_buffers = 10000
 
 # TCO timeout seconds
 # (tcp_timeout = -1 can disable the timeout check)
-tcp_timeout = 30
+tcp_timeout = -1
 
 # TCP timewait seconds
 tcp_timewait = 0

```

### Run perf

- on Client

```
./client wait 10.10.10.4 4444 100
```

- on Sender

```
python recv_3.py send 10.10.11.6 4444
```


## Epserver Epwget

> /apps/example/epserver|epwget

### Setup config/

The `setup-vm{1,2}.sh` scripts run in the `mtcp-installation` guide will have setup the required routes, and arp configurations required to run the mtcp examples.

### Run Epserver/Epwget

1. Edit `epserver.conf` and `epwget.conf` files

Change `rcvbuf` and `sndbuf` to `81920`.

2. on vm1 (server)

This example creates simple file server with epserver.

- Create test file(s) to send

```
mkdir /home/<usr>/www
echo "test" > /home/<usr>/www/testfile
```

- Start fileserver

```
cd apps/example
./epserver -p /home/<usr>/www -f epserver.conf -N 1
```

3. on vm2 (reciever)

```
./epwget 10.10.10.4/testfile 2 -N 1 -c 1 -f epwget.conf
```

### Results 

1. With both VMs set to snd/rcv buffers to `81920` 



epserver
```epserver

[CPU 0] dpdk0 flows:      0, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       0(pps),  0.00(Gbps)
[ ALL ] dpdk0 flows:      0, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       0(pps),  0.00(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   30502(pps) (err:     0),  0.02(Gbps), TX:  131633(pps),  1.62(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   30502(pps) (err:     0),  0.02(Gbps), TX:  131633(pps),  1.62(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   30593(pps) (err:     0),  0.02(Gbps), TX:  134894(pps),  1.66(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   30593(pps) (err:     0),  0.02(Gbps), TX:  134894(pps),  1.66(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   30693(pps) (err:     0),  0.02(Gbps), TX:  132668(pps),  1.63(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   30693(pps) (err:     0),  0.02(Gbps), TX:  132668(pps),  1.63(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   30025(pps) (err:     0),  0.02(Gbps), TX:  127993(pps),  1.57(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   30025(pps) (err:     0),  0.02(Gbps), TX:  127993(pps),  1.57(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   29236(pps) (err:     0),  0.02(Gbps), TX:  124881(pps),  1.54(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   29236(pps) (err:     0),  0.02(Gbps), TX:  124881(pps),  1.54(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   30551(pps) (err:     0),  0.02(Gbps), TX:  127624(pps),  1.57(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   30551(pps) (err:     0),  0.02(Gbps), TX:  127624(pps),  1.57(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   20940(pps) (err:     0),  0.02(Gbps), TX:   91197(pps),  1.12(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   20940(pps) (err:     0),  0.02(Gbps), TX:   91197(pps),  1.12(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   21552(pps) (err:     0),  0.02(Gbps), TX:   89540(pps),  1.10(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   21552(pps) (err:     0),  0.02(Gbps), TX:   89540(pps),  1.10(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   20226(pps) (err:     0),  0.01(Gbps), TX:   90359(pps),  1.11(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   20226(pps) (err:     0),  0.01(Gbps), TX:   90359(pps),  1.11(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   21906(pps) (err:     0),  0.02(Gbps), TX:   91172(pps),  1.12(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   21906(pps) (err:     0),  0.02(Gbps), TX:   91172(pps),  1.12(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   21542(pps) (err:     0),  0.02(Gbps), TX:   92014(pps),  1.13(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   21542(pps) (err:     0),  0.02(Gbps), TX:   92014(pps),  1.13(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   21096(pps) (err:     0),  0.02(Gbps), TX:   88495(pps),  1.09(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   21096(pps) (err:     0),  0.02(Gbps), TX:   88495(pps),  1.09(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   21094(pps) (err:     0),  0.02(Gbps), TX:   89463(pps),  1.10(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   21094(pps) (err:     0),  0.02(Gbps), TX:   89463(pps),  1.10(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   14940(pps) (err:     0),  0.01(Gbps), TX:   66789(pps),  0.82(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   14940(pps) (err:     0),  0.01(Gbps), TX:   66789(pps),  0.82(Gbps)
[CPU 0] dpdk0 flows:      0, RX:    1136(pps) (err:     0),  0.00(Gbps), TX:    4647(pps),  0.06(Gbps)
[ ALL ] dpdk0 flows:      0, RX:    1136(pps) (err:     0),  0.00(Gbps), TX:    4647(pps),  0.06(Gbps)
[CPU 0] dpdk0 flows:      0, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       0(pps),  0.00(Gbps)
[ ALL ] dpdk0 flows:      0, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       0(pps),  0.00(Gbps)
[CPU 0] dpdk0 flows:      0, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       0(pps),  0.00(Gbps)


```

epwget
```epwget
[mtcp_create_context:1359] CPU 0 is now the master thread.
Thread 0 handles 2 flows. connecting to 10.10.10.4:80
[CPU 0] dpdk0 flows:      1, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       1(pps),  0.00(Gbps)
[ ALL ] dpdk0 flows:      1, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       1(pps),  0.00(Gbps)
[ ALL ] connect:       1, read:  135 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:  133795(pps) (err:     0),  1.65(Gbps), TX:   30999(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:  133795(pps) (err:     0),  1.65(Gbps), TX:   30999(pps),  0.02(Gbps)
[ ALL ] connect:       0, read:  183 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:  134513(pps) (err:     0),  1.66(Gbps), TX:   30535(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:  134513(pps) (err:     0),  1.66(Gbps), TX:   30535(pps),  0.02(Gbps)
[ ALL ] connect:       0, read:  185 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:  133251(pps) (err:     0),  1.64(Gbps), TX:   30827(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:  133251(pps) (err:     0),  1.64(Gbps), TX:   30827(pps),  0.02(Gbps)
[ ALL ] connect:       0, read:  179 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:  127435(pps) (err:     0),  1.57(Gbps), TX:   29880(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:  127435(pps) (err:     0),  1.57(Gbps), TX:   29880(pps),  0.02(Gbps)
[ ALL ] connect:       0, read:  172 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:  125360(pps) (err:     0),  1.54(Gbps), TX:   29257(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:  125360(pps) (err:     0),  1.54(Gbps), TX:   29257(pps),  0.02(Gbps)
Response size set to 1073741972
[ ALL ] connect:       1, read:  179 MB, write:    0 MB, completes:       1 (resp_time avg: 5654902, max: 5654902 us)
[CPU 0] dpdk0 flows:      1, RX:  127408(pps) (err:     0),  1.57(Gbps), TX:   30616(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:  127408(pps) (err:     0),  1.57(Gbps), TX:   30616(pps),  0.02(Gbps)
[ ALL ] connect:       0, read:  135 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   90746(pps) (err:     0),  1.12(Gbps), TX:   20825(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   90746(pps) (err:     0),  1.12(Gbps), TX:   20825(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:  123 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   89349(pps) (err:     0),  1.10(Gbps), TX:   21500(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   89349(pps) (err:     0),  1.10(Gbps), TX:   21500(pps),  0.02(Gbps)
[ ALL ] connect:       0, read:  123 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   89994(pps) (err:     0),  1.11(Gbps), TX:   20138(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   89994(pps) (err:     0),  1.11(Gbps), TX:   20138(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:  128 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   91461(pps) (err:     0),  1.13(Gbps), TX:   21972(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   91461(pps) (err:     0),  1.13(Gbps), TX:   21972(pps),  0.02(Gbps)
[ ALL ] connect:       0, read:  124 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   92348(pps) (err:     0),  1.14(Gbps), TX:   21592(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   92348(pps) (err:     0),  1.14(Gbps), TX:   21592(pps),  0.02(Gbps)
[ ALL ] connect:       0, read:  122 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   88022(pps) (err:     0),  1.08(Gbps), TX:   21024(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   88022(pps) (err:     0),  1.08(Gbps), TX:   21024(pps),  0.02(Gbps)
[ ALL ] connect:       0, read:  124 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   89373(pps) (err:     0),  1.10(Gbps), TX:   21086(pps),  0.02(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   89373(pps) (err:     0),  1.10(Gbps), TX:   21086(pps),  0.02(Gbps)
[ ALL ] connect:       0, read:   99 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   66773(pps) (err:     0),  0.82(Gbps), TX:   14933(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   66773(pps) (err:     0),  0.82(Gbps), TX:   14933(pps),  0.01(Gbps)
[CPU 0] Completed 2 connections, errors: 0 incompletes: 0
[RunMainLoop: 876] MTCP thread 0 finished.
[mtcp_free_context:1405] MTCP thread 0 joined.
[mtcp_destroy:1676] All MTCP threads are joined.



```


2. Results with Rate Limitation

Epserver
```
[ ALL ] dpdk0 flows:      0, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       0(pps),  0.00(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   15662(pps) (err:     0),  0.01(Gbps), TX:   37851(pps),  0.46(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   15662(pps) (err:     0),  0.01(Gbps), TX:   37851(pps),  0.46(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   16448(pps) (err:     0),  0.01(Gbps), TX:   41569(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   16448(pps) (err:     0),  0.01(Gbps), TX:   41569(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   15191(pps) (err:     0),  0.01(Gbps), TX:   41572(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   15191(pps) (err:     0),  0.01(Gbps), TX:   41572(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   16557(pps) (err:     0),  0.01(Gbps), TX:   41576(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   16557(pps) (err:     0),  0.01(Gbps), TX:   41576(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   17000(pps) (err:     0),  0.01(Gbps), TX:   41576(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   17000(pps) (err:     0),  0.01(Gbps), TX:   41576(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   16838(pps) (err:     0),  0.01(Gbps), TX:   41579(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   16838(pps) (err:     0),  0.01(Gbps), TX:   41579(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   17054(pps) (err:     0),  0.01(Gbps), TX:   41576(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   17054(pps) (err:     0),  0.01(Gbps), TX:   41576(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   15512(pps) (err:     0),  0.01(Gbps), TX:   41572(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   15512(pps) (err:     0),  0.01(Gbps), TX:   41572(pps),  0.51(Gbps)
[  ARPTimer: 323] [CPU 0] ARP request for 10.10.10.4 timed out.
[CPU 0] dpdk0 flows:      1, RX:   14337(pps) (err:     0),  0.01(Gbps), TX:   41574(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   14337(pps) (err:     0),  0.01(Gbps), TX:   41574(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   13658(pps) (err:     0),  0.01(Gbps), TX:   41574(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   13658(pps) (err:     0),  0.01(Gbps), TX:   41574(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   16374(pps) (err:     0),  0.01(Gbps), TX:   41728(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   16374(pps) (err:     0),  0.01(Gbps), TX:   41728(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   19538(pps) (err:     0),  0.01(Gbps), TX:   41245(pps),  0.50(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   19538(pps) (err:     0),  0.01(Gbps), TX:   41245(pps),  0.50(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   11629(pps) (err:     0),  0.01(Gbps), TX:   41538(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   11629(pps) (err:     0),  0.01(Gbps), TX:   41538(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   10321(pps) (err:     0),  0.01(Gbps), TX:   40836(pps),  0.50(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   10321(pps) (err:     0),  0.01(Gbps), TX:   40836(pps),  0.50(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   13226(pps) (err:     0),  0.01(Gbps), TX:   41279(pps),  0.50(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   13226(pps) (err:     0),  0.01(Gbps), TX:   41279(pps),  0.50(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   14011(pps) (err:     0),  0.01(Gbps), TX:   41568(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   14011(pps) (err:     0),  0.01(Gbps), TX:   41568(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   12994(pps) (err:     0),  0.01(Gbps), TX:   41489(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   12994(pps) (err:     0),  0.01(Gbps), TX:   41489(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   11158(pps) (err:     0),  0.01(Gbps), TX:   39422(pps),  0.48(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   11158(pps) (err:     0),  0.01(Gbps), TX:   39422(pps),  0.48(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   12046(pps) (err:     0),  0.01(Gbps), TX:   41562(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   12046(pps) (err:     0),  0.01(Gbps), TX:   41562(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   11646(pps) (err:     0),  0.01(Gbps), TX:   41451(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   11646(pps) (err:     0),  0.01(Gbps), TX:   41451(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   10994(pps) (err:     0),  0.01(Gbps), TX:   39697(pps),  0.49(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   10994(pps) (err:     0),  0.01(Gbps), TX:   39697(pps),  0.49(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   12091(pps) (err:     0),  0.01(Gbps), TX:   41512(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   12091(pps) (err:     0),  0.01(Gbps), TX:   41512(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   13310(pps) (err:     0),  0.01(Gbps), TX:   41562(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   13310(pps) (err:     0),  0.01(Gbps), TX:   41562(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   12357(pps) (err:     0),  0.01(Gbps), TX:   41564(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   12357(pps) (err:     0),  0.01(Gbps), TX:   41564(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   13225(pps) (err:     0),  0.01(Gbps), TX:   41561(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   13225(pps) (err:     0),  0.01(Gbps), TX:   41561(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   13524(pps) (err:     0),  0.01(Gbps), TX:   41573(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   13524(pps) (err:     0),  0.01(Gbps), TX:   41573(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   16003(pps) (err:     0),  0.01(Gbps), TX:   41476(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   16003(pps) (err:     0),  0.01(Gbps), TX:   41476(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   14824(pps) (err:     0),  0.01(Gbps), TX:   41508(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   14824(pps) (err:     0),  0.01(Gbps), TX:   41508(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   12772(pps) (err:     0),  0.01(Gbps), TX:   41524(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   12772(pps) (err:     0),  0.01(Gbps), TX:   41524(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   12690(pps) (err:     0),  0.01(Gbps), TX:   41576(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   12690(pps) (err:     0),  0.01(Gbps), TX:   41576(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   12680(pps) (err:     0),  0.01(Gbps), TX:   41549(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   12680(pps) (err:     0),  0.01(Gbps), TX:   41549(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   13586(pps) (err:     0),  0.01(Gbps), TX:   41579(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   13586(pps) (err:     0),  0.01(Gbps), TX:   41579(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   14128(pps) (err:     0),  0.01(Gbps), TX:   41574(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   14128(pps) (err:     0),  0.01(Gbps), TX:   41574(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   13181(pps) (err:     0),  0.01(Gbps), TX:   41346(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   13181(pps) (err:     0),  0.01(Gbps), TX:   41346(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   13353(pps) (err:     0),  0.01(Gbps), TX:   41479(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   13353(pps) (err:     0),  0.01(Gbps), TX:   41479(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   13406(pps) (err:     0),  0.01(Gbps), TX:   41393(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   13406(pps) (err:     0),  0.01(Gbps), TX:   41393(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      1, RX:   13004(pps) (err:     0),  0.01(Gbps), TX:   41677(pps),  0.51(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   13004(pps) (err:     0),  0.01(Gbps), TX:   41677(pps),  0.51(Gbps)
[CPU 0] dpdk0 flows:      0, RX:    5539(pps) (err:     0),  0.00(Gbps), TX:   16661(pps),  0.20(Gbps)
[ ALL ] dpdk0 flows:      0, RX:    5539(pps) (err:     0),  0.00(Gbps), TX:   16661(pps),  0.20(Gbps)
[CPU 0] dpdk0 flows:      0, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       0(pps),  0.00(Gbps)
[ ALL ] dpdk0 flows:      0, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       0(pps),  0.00(Gbps)
[CPU 0] dpdk0 flows:      0, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       0(pps),  0.00(Gbps)


```


Epwget
```
[mtcp_create_context:1359] CPU 0 is now the master thread.
Thread 0 handles 2 flows. connecting to 10.10.10.4:80
[CPU 0] dpdk0 flows:      1, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       1(pps),  0.00(Gbps)
[ ALL ] dpdk0 flows:      1, RX:       0(pps) (err:     0),  0.00(Gbps), TX:       1(pps),  0.00(Gbps)
[ ALL ] connect:       1, read:   27 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41626(pps) (err:     0),  0.51(Gbps), TX:   17337(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41626(pps) (err:     0),  0.51(Gbps), TX:   17337(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41573(pps) (err:     0),  0.51(Gbps), TX:   16189(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41573(pps) (err:     0),  0.51(Gbps), TX:   16189(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41573(pps) (err:     0),  0.51(Gbps), TX:   15294(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41573(pps) (err:     0),  0.51(Gbps), TX:   15294(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41576(pps) (err:     0),  0.51(Gbps), TX:   16495(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41576(pps) (err:     0),  0.51(Gbps), TX:   16495(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41575(pps) (err:     0),  0.51(Gbps), TX:   16947(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41575(pps) (err:     0),  0.51(Gbps), TX:   16947(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41571(pps) (err:     0),  0.51(Gbps), TX:   16936(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41571(pps) (err:     0),  0.51(Gbps), TX:   16936(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41543(pps) (err:     0),  0.51(Gbps), TX:   17062(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41543(pps) (err:     0),  0.51(Gbps), TX:   17062(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41611(pps) (err:     0),  0.51(Gbps), TX:   15331(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41611(pps) (err:     0),  0.51(Gbps), TX:   15331(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41576(pps) (err:     0),  0.51(Gbps), TX:   14229(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41576(pps) (err:     0),  0.51(Gbps), TX:   14229(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   57 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41569(pps) (err:     0),  0.51(Gbps), TX:   13695(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41569(pps) (err:     0),  0.51(Gbps), TX:   13695(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41543(pps) (err:     0),  0.51(Gbps), TX:   17035(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41543(pps) (err:     0),  0.51(Gbps), TX:   17035(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   26 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[  ARPTimer: 323] [CPU 0] ARP request for 10.10.11.6 timed out.
[CPU 0] dpdk0 flows:      1, RX:   41419(pps) (err:     0),  0.51(Gbps), TX:   18520(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41419(pps) (err:     0),  0.51(Gbps), TX:   18520(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   43 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41534(pps) (err:     0),  0.51(Gbps), TX:   11774(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41534(pps) (err:     0),  0.51(Gbps), TX:   11774(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   40852(pps) (err:     0),  0.50(Gbps), TX:   10281(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   40852(pps) (err:     0),  0.50(Gbps), TX:   10281(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   54 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41192(pps) (err:     0),  0.50(Gbps), TX:   13388(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41192(pps) (err:     0),  0.50(Gbps), TX:   13388(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   53 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41649(pps) (err:     0),  0.51(Gbps), TX:   14072(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41649(pps) (err:     0),  0.51(Gbps), TX:   14072(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41486(pps) (err:     0),  0.51(Gbps), TX:   12914(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41486(pps) (err:     0),  0.51(Gbps), TX:   12914(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   55 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   39423(pps) (err:     0),  0.48(Gbps), TX:   11130(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   39423(pps) (err:     0),  0.48(Gbps), TX:   11130(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   55 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
Response size set to 1073741972
[CPU 0] dpdk0 flows:      1, RX:   41565(pps) (err:     0),  0.51(Gbps), TX:   12130(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41565(pps) (err:     0),  0.51(Gbps), TX:   12130(pps),  0.01(Gbps)
[ ALL ] connect:       1, read:   56 MB, write:    0 MB, completes:       1 (resp_time avg: 18911213, max: 18911213 us)
[CPU 0] dpdk0 flows:      1, RX:   41503(pps) (err:     0),  0.51(Gbps), TX:   11563(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41503(pps) (err:     0),  0.51(Gbps), TX:   11563(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   39652(pps) (err:     0),  0.48(Gbps), TX:   11117(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   39652(pps) (err:     0),  0.48(Gbps), TX:   11117(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   54 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41507(pps) (err:     0),  0.51(Gbps), TX:   12163(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41507(pps) (err:     0),  0.51(Gbps), TX:   12163(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41572(pps) (err:     0),  0.51(Gbps), TX:   13063(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41572(pps) (err:     0),  0.51(Gbps), TX:   13063(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   57 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41549(pps) (err:     0),  0.51(Gbps), TX:   12308(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41549(pps) (err:     0),  0.51(Gbps), TX:   12308(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41552(pps) (err:     0),  0.51(Gbps), TX:   13491(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41552(pps) (err:     0),  0.51(Gbps), TX:   13491(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41584(pps) (err:     0),  0.51(Gbps), TX:   13504(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41584(pps) (err:     0),  0.51(Gbps), TX:   13504(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41430(pps) (err:     0),  0.51(Gbps), TX:   16618(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41430(pps) (err:     0),  0.51(Gbps), TX:   16618(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   36 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41561(pps) (err:     0),  0.51(Gbps), TX:   14187(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41561(pps) (err:     0),  0.51(Gbps), TX:   14187(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41520(pps) (err:     0),  0.51(Gbps), TX:   12684(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41520(pps) (err:     0),  0.51(Gbps), TX:   12684(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41579(pps) (err:     0),  0.51(Gbps), TX:   12515(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41579(pps) (err:     0),  0.51(Gbps), TX:   12515(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41536(pps) (err:     0),  0.51(Gbps), TX:   12845(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41536(pps) (err:     0),  0.51(Gbps), TX:   12845(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41587(pps) (err:     0),  0.51(Gbps), TX:   13713(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41587(pps) (err:     0),  0.51(Gbps), TX:   13713(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41574(pps) (err:     0),  0.51(Gbps), TX:   14087(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41574(pps) (err:     0),  0.51(Gbps), TX:   14087(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41261(pps) (err:     0),  0.50(Gbps), TX:   12881(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41261(pps) (err:     0),  0.50(Gbps), TX:   12881(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41568(pps) (err:     0),  0.51(Gbps), TX:   13657(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41568(pps) (err:     0),  0.51(Gbps), TX:   13657(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41531(pps) (err:     0),  0.51(Gbps), TX:   13247(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41531(pps) (err:     0),  0.51(Gbps), TX:   13247(pps),  0.01(Gbps)
[ ALL ] connect:       0, read:   56 MB, write:    0 MB, completes:       0 (resp_time avg:    0, max:      0 us)
[CPU 0] dpdk0 flows:      1, RX:   41504(pps) (err:     0),  0.51(Gbps), TX:   13089(pps),  0.01(Gbps)
[ ALL ] dpdk0 flows:      1, RX:   41504(pps) (err:     0),  0.51(Gbps), TX:   13089(pps),  0.01(Gbps)
[CPU 0] Completed 2 connections, errors: 0 incompletes: 0
[RunMainLoop: 876] MTCP thread 0 finished.
[mtcp_free_context:1405] MTCP thread 0 joined.
[mtcp_destroy:1676] All MTCP threads are joined.

```

Router
```
Every 2.0s: tc -s -d qdisc ls dev enp0s9                                                                            Wed Jun 22 14:10:05 2022

qdisc tbf 8001: root refcnt 2 rate 500Mbit burst 262125b/1 mpu 0b lat 50.0ms linklayer ethernet
 Sent 2322898734 bytes 1544947 pkt (dropped 0, overlimits 563515 requeues 35)
 backlog 0b 0p requeues 35


```