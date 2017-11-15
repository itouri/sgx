sudo lttng create my-kernel-session --output=$HOME/sgx-trace
sudo enable-event --kernel --all
sudo lttng start

sudo stop
sudo chmod 755 -R $HOME/sgx-trace
