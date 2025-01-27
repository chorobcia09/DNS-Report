#!/bin/bash

input_file=$1
datetime=$(date +%Y-%m-%d_%H-%M-%S)
output_file="Raport_DNS_${datetime}.txt"
> $output_file

process_whois_info() {
  entry=$1
  whois_output=$(whois $entry | sed -e '/^>>> Last update of WHOIS database:/,/^$/d' \
                                    -e '/^For more information on WHOIS status codes/,/^$/d' \
                                    -e '/^If you wish to contact this domain’s Registrant/,/^$/d' \
                                    -e '/^Web-based WHOIS:/,/^$/d' \
                                    -e '/^If you have a legitimate interest/,/^$/d' \
                                    -e '/^The data in MarkMonitor’s WHOIS database/,/^$/d' \
                                    -e '/^By submitting a WHOIS query/,/^$/d' \
                                    -e '/^MarkMonitor Domain Management/,/^$/d' \
                                    -e '/^NOTICE:/,/^$/d' \
                                    -e '/^TERMS OF USE:/,/^$/d' \
                                    -e '/^URL of the ICANN WHOIS Data Problem Reporting System:/,/^$/d' \
                                    -e '/^#/d' \
                                    -e '/^DNSSEC: unsigned/,$d')

  echo "$whois_output" >> $output_file
  echo "----------------------------------------" >> $output_file
}

while IFS= read -r line
do
  if [[ -z "$line" ]]; then
    continue
  fi

  if [[ $line =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "IP: $line" >> $output_file
    echo "Sprawdzanie informacji o adresie IP..." >> $output_file
    process_whois_info $line
  else
    echo "Domena: $line" >> $output_file
    echo "Sprawdzanie informacji o domenie..." >> $output_file
    process_whois_info $line
  fi
  echo "------------------------" >> $output_file
done < "$input_file"