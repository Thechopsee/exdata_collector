#!/bin/bash

cd "$(dirname "$0")"

CONFIG="local"

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--config)
            CONFIG="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [-c|--config CONFIG]"
            echo ""
            echo "Options:"
            echo "  -c, --config CONFIG    Configuration to use (local, local2, production)"
            echo "  -h, --help             Show this help message"
            echo ""
            echo "Available configurations:"
            echo "  local      - Local development (192.168.1.27:5000, debug=True)"
            echo "  local2     - Alternative local (10.0.0.19:5000, debug=True)"
            echo "  production - Production deployment (10.0.0.19:5051, debug=False)"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

echo "Using configuration: $CONFIG"
python3 DataColector.py "$CONFIG"
