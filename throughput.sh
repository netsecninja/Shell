# Throughput Test

# Variables
# File must be above 50 MB, because the proxies cache anything under that size.
file=http://ipv4.download.thinkbroadband.com/200MB.zip
report=report.csv
results=fulllog.txt

# Get file
cd /home/jbess/throughput
rm $results
wget -a $results $file

# Get results (date, time, rate, unit)
echo -n $(tail -2 $results | grep .zip | cut -d " " -f 1),>> $report # Date
echo -n $(tail -2 $results | grep .zip | cut -d " " -f 2),>> $report # Time
echo -n $(tail -2 $results | grep .zip | cut -d "(" -f 2 | cut -d ")" -f 1 | cut -d " " -f 1),>> $report # Rate
echo $(tail -2 $results | grep .zip | cut -d "(" -f 2 | cut -d ")" -f 1 | cut -d " " -f 2) >> $report # Unit

# Clean up
rm 200MB.zip