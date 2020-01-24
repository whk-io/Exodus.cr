build:
	clear && crystal build --release --static src/exodus.cr && ./exodus -p /bin/tar
	unzip -l exodus.zip
	rm exodus.zip
	rm exodus