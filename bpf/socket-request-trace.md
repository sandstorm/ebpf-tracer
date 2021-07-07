# socket-request-trace

Dumps the payload of all request to a given target (arg3 - arg7) for processes with arg1 <= PID <= arg2.

## Usage

```bash
# trace processes with 48147 <= PID <= 48147 to 10.20.30.40:6379
bpftrace /bpf/socket-request-trace.bt 48147 48147 10 20 30 40 6379
# stop measurements with Ctrl + C
```

## Example Result

```
Attaching 5 probes...
Tracing requests for processes 48147 (arg1) <= PID <= 48147 (arg2) to 10.20.30.40:6379 (arg3 - arg7)

Tracing FD 7 for target 10.20.30.40:6379
23 - *2\x0d\x0a$6\x0d\x0aSELECT\x0d\x0a$1\x0d\x0a2\x0d\x0a
80 - *2\x0d\x0a$3\x0d\x0aGET\x0d\x0a$60\x0d\x0aFlow_Session_MetaData:entry:dctRCgKqgj081lIDb1tmH4GUxLmdUHs0\x0d\x0a
Tracing FD 8 for target 10.20.30.40:6379
23 - *2\x0d\x0a$6\x0d\x0aSELECT\x0d\x0a$1\x0d\x0a3\x0d\x0a
80 - *2\x0d\x0a$3\x0d\x0aGET\x0d\x0a$60\x0d\x0aFlow_Session_MetaData:entry:dctRCgKqgj081lIDb1tmH4GUxLmdUHs0\x0d\x0a
…
```
