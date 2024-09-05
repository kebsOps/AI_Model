import re
import logging

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def safe_parse_host_port(host_port):
    logger.debug(f"Parsing host_port: {host_port}")
    if host_port.startswith('['):
        # IPv6 address
        match = re.match(r'\[(?P<host>.*)\]:(?P<port>\d+)', host_port)
        if match:
            return match.group('host'), int(match.group('port'))
    else:
        # IPv4 address or hostname
        match = re.match(r'(?P<host>.*):(?P<port>\d+)', host_port)
        if match:
            return match.group('host'), int(match.group('port'))
    
    # If no match, return a default
    logger.warning(f"Could not parse host_port: {host_port}. Using default.")
    return host_port, 7860

# Add this function to the launch_utils.py file
# and replace any existing host/port parsing logic with calls to this function