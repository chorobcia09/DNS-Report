# DNS Report Script

## Overview
The DNS Report script is a tool designed to generate reports containing WHOIS information for IP addresses and domain names. It uses the `whois` command to retrieve data and filters the results before saving them to a text file.

---

## Requirements
To run the script successfully, the following tools must be installed on the system:

- **Bash:** A command-line shell, standard in most Linux and macOS systems.
- **whois:** A command-line tool for WHOIS queries. Install it using:
  ```bash
  sudo apt-get install whois
  ```

---

## How to Use
1. Save the script as `script.sh`.
2. Make the script executable:
   ```bash
   chmod +x script.sh
   ```
3. Run the script with an input file containing a list of IP addresses or domain names:
   ```bash
   ./script.sh input_file.txt
   ```

### Input File Format
- Each line should contain either an IP address or a domain name.
- Empty lines will be ignored.

Example:
```
192.168.0.1
google.com
example.org
```

---

## Script Structure

### Preparing the Output File
The script initializes variables to manage the input and output files:
```bash
input_file=$1
datetime=$(date +%Y-%m-%d_%H-%M-%S)
output_file="Raport_DNS_${datetime}.txt"
> $output_file
```
- `input_file`: The name of the input file, passed as the first argument.
- `datetime`: The current date and time in `YYYY-MM-DD_HH-MM-SS` format.
- `output_file`: The name of the output file where results will be saved.

### Function: `process_whois_info`
Processes WHOIS information for a given IP address or domain:
```bash
process_whois_info() {
  entry=$1
  whois_output=$(whois $entry | sed -e '...' -e '...' -e '...')
  echo "$whois_output" >> $output_file
  echo "----------------------------------------" >> $output_file
}
```
- Filters the WHOIS output using `sed`.
- Appends the filtered data to the output file.

### Main Processing Loop
The script processes each line of the input file:
```bash
while IFS= read -r line
do
  if [[ -z "$line" ]]; then
    continue
  fi

  if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "IP: $line" >> $output_file
    echo "Checking IP information..." >> $output_file
    process_whois_info $line
  else
    echo "Domain: $line" >> $output_file
    echo "Checking domain information..." >> $output_file
    process_whois_info $line
  fi
  echo "------------------------" >> $output_file
done < "$input_file"
```
- Reads each line of the input file.
- Skips empty lines.
- Differentiates between IP addresses and domain names.
- Calls the `process_whois_info` function for each entry.

---

## Output
The script generates a report file named `Raport_DNS_<date_time>.txt`. Each entry includes:
- The type of entry (IP or domain).
- Filtered WHOIS information.
- A separator line for readability.

Example output:
```
IP: 192.168.0.1
Checking IP information...
<Filtered WHOIS data>
----------------------------------------
Domain: google.com
Checking domain information...
<Filtered WHOIS data>
----------------------------------------
```

---

## Advantages
- **Automation:** Automates the collection of WHOIS data.
- **Filtering:** Provides only the most relevant information.
- **Customizable:** Easily adjustable for specific user needs.

---

