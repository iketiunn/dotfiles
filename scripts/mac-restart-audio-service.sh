# When sound blaters for no reanson
sudo kill -9 `ps -ax | grep 'coreaudio[d]' | awk '{print $1}'`
