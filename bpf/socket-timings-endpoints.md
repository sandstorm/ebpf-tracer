# (NOT YET WORKING CORRECTLY) socket-timings-endpoints.bf

Monitors round-trip times of request for processes with arg1 <= PID <= arg2 and prints a histogram of round-trip times in µs. The histogram shows 100 µs buckets from 0 to 5k µs **and the target IP and port**.

It's socket-timings.bt, but extended by soconnect.bt; so that it is indexed by IP and Port properly.

Note that the last request is not included into the measurements! This should be ok, since this script gives an overview over many requests.

## Usage

```bash
# (optional) start local test process
php -r 'while(true) { file_get_contents("https://sandstorm.de"); echo "."; sleep(2); }'
# search for PID, e.g. of php process
ps faux | grep -i php
# trace processes with 2929 <= PID <= 2929
bpftrace socket-timings.bt 2929 2929
# stop measurements with Ctrl + C
```

## Example Result

TODO: add output when it is correct
