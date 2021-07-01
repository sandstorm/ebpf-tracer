# socket-timings.bf

Monitors round-trip times of request for processes with arg1 <= PID <= arg2 and prints a histogram of round-trip times in µs. The histogram shows 100 µs buckets from 0 to 5k µs.

Note that the last request is not included into the measurements! This should be ok, since this script gives an overview over many requests.

## Usage

```bash
# (optional) start process for local testing
php -r 'while(true) { file_get_contents("https://sandstorm.de"); echo "."; sleep(2); }'
# search for PID, e.g. of php process
ps faux | grep -i php
# trace processes with 2929 <= PID <= 2929
bpftrace socket-timings.bt 2929 2929
# stop measurements with Ctrl + C
```

## Example Result

Note that this example output is not for `php` since it would be too boring.

```
Attaching 5 probes...
Monitoring round-trip times of request for processes with 2929 (arg1) <= PID <= 2929 (arg2)
^C

Latency Histogram from the start of the first request to the start of the first reply.
Indexed by PID, FD in µs

@us[2929, 9]:
[400, 500)             9 |@@                                                  |
[500, 600)            66 |@@@@@@@@@@@@@@@@@@@                                 |
[600, 700)            89 |@@@@@@@@@@@@@@@@@@@@@@@@@@                          |
[700, 800)           175 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[800, 900)           138 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           |
[900, 1000)           85 |@@@@@@@@@@@@@@@@@@@@@@@@@                           |
[1000, 1100)          64 |@@@@@@@@@@@@@@@@@@@                                 |
[1100, 1200)          35 |@@@@@@@@@@                                          |
[1200, 1300)          19 |@@@@@                                               |
[1300, 1400)          32 |@@@@@@@@@                                           |
[1400, 1500)          32 |@@@@@@@@@                                           |
[1500, 1600)          55 |@@@@@@@@@@@@@@@@                                    |
[1600, 1700)          24 |@@@@@@@                                             |
[1700, 1800)          17 |@@@@@                                               |
[1800, 1900)           6 |@                                                   |
[1900, 2000)           4 |@                                                   |
[2000, 2100)           1 |                                                    |
[2100, 2200)           4 |@                                                   |
[2200, 2300)           1 |                                                    |
[2300, 2400)           1 |                                                    |
[2400, 2500)           2 |                                                    |
[2500, 2600)           0 |                                                    |
[2600, 2700)           1 |                                                    |
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
[5000, ...)            2 |                                                    |

… (similar histograms for other sockets)
```
