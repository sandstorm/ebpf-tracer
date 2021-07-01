# soconnect.bt

Shows TCP/IP connects for processes with arg1 <= PID <= arg2 and prints them instantly.

## Usage

```bash
# (optional) start wget-loop for local testing
watch wget sandstorm.de
# search for PID, e.g. of ping process
ps faux | grep -i watch
# trace processes with 5055 <= PID <= 5055 + 1000
bpftrace socket-timings.bt 5055 6055
# terminate with Ctrl + C
```

## Example Result

```
Attaching 4 probes...
Showing TCP/IP connects for processes with 5055 (arg1) <= PID <= 6055 (arg2)
PID    FD     PROCESS          FAM ADDRESS          PORT  LAT(µs) RESULT
5327   3      wget             2   192.168.65.5     53          20 Success
5327   3      wget             2   192.168.65.5     53          86 Success
5327   3      wget             2   178.63.128.131   80       16460 Success
5328   3      wget             2   192.168.65.5     53          17 Success
5328   3      wget             2   192.168.65.5     53          17 Success
5328   3      wget             2   178.63.128.131   80       16924 Success
5329   3      wget             2   192.168.65.5     53          41 Success
5329   3      wget             2   192.168.65.5     53          19 Success
5329   3      wget             2   178.63.128.131   80       16310 Success
5330   3      wget             2   192.168.65.5     53          21 Success
5330   3      wget             2   192.168.65.5     53          25 Success
5330   3      wget             2   178.63.128.131   80       16386 Success
^C
```
