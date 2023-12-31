# socket-timings-endpoints.bt

Monitors round-trip times of request for processes with arg1 <= PID <= arg2 and prints a histogram of round-trip times in µs. The histogram shows 100 µs buckets from 0 to 5k µs **and the target IP and port**.

It's _socket-timings.bt_, but extended by soconnect.bt; so that it is indexed by IP and Port properly.

Note that the last request is not included into the measurements! This should be ok, since this script gives an overview over many requests.

Do not get confused: there is no one-to-one mapping between FD and IP:Port.

## Usage

```bash
# trace processes with 2929 <= PID <= 2929
bpftrace socket-timings-endpoints.bt 589 606
# stop measurements with Ctrl + C
```

## Example Result

```
Attaching 7 probes...
Monitoring round-trip times of request for processes with 589 (arg1) <= PID <= 606 (arg2)
^C

Latency Histogram from the start of the first request to the start of the first reply.
Indexed by PID, FD in µs

@us[599, 2.3.4.5, 5432]:
[300, 400)             1 |                                                    |
[400, 500)             3 |@@                                                  |
[500, 600)             9 |@@@@@@@                                             |
[600, 700)            26 |@@@@@@@@@@@@@@@@@@@@@@                              |
[700, 800)            28 |@@@@@@@@@@@@@@@@@@@@@@@@                            |
[800, 900)            52 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       |
[900, 1000)           60 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[1000, 1100)          38 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                    |
[1100, 1200)          40 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  |
[1200, 1300)          27 |@@@@@@@@@@@@@@@@@@@@@@@                             |
[1300, 1400)          20 |@@@@@@@@@@@@@@@@@                                   |
[1400, 1500)          22 |@@@@@@@@@@@@@@@@@@@                                 |
[1500, 1600)          37 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                    |
[1600, 1700)          23 |@@@@@@@@@@@@@@@@@@@                                 |
[1700, 1800)          14 |@@@@@@@@@@@@                                        |
[1800, 1900)           8 |@@@@@@                                              |
[1900, 2000)           4 |@@@                                                 |
[2000, 2100)           3 |@@                                                  |
[2100, 2200)           4 |@@@                                                 |
[2200, 2300)           1 |                                                    |
[2300, 2400)           2 |@                                                   |
[2400, 2500)           0 |                                                    |
[2500, 2600)           0 |                                                    |
[2600, 2700)           1 |                                                    |
[2700, 2800)           0 |                                                    |
[2800, 2900)           0 |                                                    |
[2900, 3000)           0 |                                                    |
[3000, 3100)           1 |                                                    |
[3100, 3200)           0 |                                                    |
[3200, 3300)           0 |                                                    |
[3300, 3400)           0 |                                                    |
[3400, 3500)           0 |                                                    |
[3500, 3600)           1 |                                                    |
[3600, 3700)           0 |                                                    |
[3700, 3800)           0 |                                                    |
[3800, 3900)           0 |                                                    |
[3900, 4000)           0 |                                                    |
[4000, 4100)           0 |                                                    |
[4100, 4200)           0 |                                                    |
[4200, 4300)           0 |                                                    |
[4300, 4400)           0 |                                                    |
[4400, 4500)           0 |                                                    |
[4500, 4600)           0 |                                                    |
[4600, 4700)           0 |                                                    |
[4700, 4800)           0 |                                                    |
[4800, 4900)           0 |                                                    |
[4900, 5000)           0 |                                                    |
[5000, ...)            1 |                                                    |

@us[599, 1.2.3.4, 6379]:
[100, 200)           636 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[200, 300)           127 |@@@@@@@@@@                                          |
[300, 400)            39 |@@@                                                 |
[400, 500)            17 |@                                                   |
[500, 600)             4 |                                                    |
[600, 700)             1 |                                                    |
[700, 800)             0 |                                                    |
[800, 900)             0 |                                                    |
[900, 1000)            0 |                                                    |
[1000, 1100)           0 |                                                    |
[1100, 1200)           0 |                                                    |
[1200, 1300)           0 |                                                    |
[1300, 1400)           0 |                                                    |
[1400, 1500)           1 |                                                    |
[1500, 1600)           0 |                                                    |
[1600, 1700)           1 |                                                    |
[1700, 1800)           2 |                                                    |
[1800, 1900)           1 |                                                    |
[1900, 2000)           0 |                                                    |
[2000, 2100)           0 |                                                    |
[2100, 2200)           0 |                                                    |
[2200, 2300)           0 |                                                    |
[2300, 2400)           0 |                                                    |
[2400, 2500)           0 |                                                    |
[2500, 2600)           0 |                                                    |
[2600, 2700)           0 |                                                    |
[2700, 2800)           0 |                                                    |
[2800, 2900)           0 |                                                    |
[2900, 3000)           0 |                                                    |
[3000, 3100)           0 |                                                    |
[3100, 3200)           0 |                                                    |
[3200, 3300)           0 |                                                    |
[3300, 3400)           0 |                                                    |
[3400, 3500)           0 |                                                    |
[3500, 3600)           0 |                                                    |
[3600, 3700)           0 |                                                    |
[3700, 3800)           1 |                                                    |
```
