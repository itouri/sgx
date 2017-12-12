# trece the app
lttng-sessiond --daemonize
lttng create sgx-session
lttng enable-event --userspace sgx_trace:my_first_tracepoint
lttng start
./app
lttng stop
lttng destroy