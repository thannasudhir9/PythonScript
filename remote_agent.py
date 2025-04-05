import socket
import subprocess
import threading

# Configuration
HOST = '0.0.0.0'  # Listen on all interfaces
PORT = 9999       # You can customize the port
AUTH_TOKEN = "your_secure_token"  # Pre-shared token

# Whitelisted commands
ALLOWED_COMMANDS = ['whoami', 'hostname', 'ipconfig', 'ifconfig', 'uptime', 'dir', 'ls', 'tasklist']

def handle_client(conn, addr):
    print(f"[+] Connection from {addr}")
    try:
        conn.send(b"AUTH_TOKEN: ")
        token = conn.recv(1024).decode().strip()
        if token != AUTH_TOKEN:
            conn.send(b"Unauthorized\n")
            conn.close()
            return
        conn.send(b"Connected. Type command:\n")

        while True:
            conn.send(b"> ")
            cmd = conn.recv(1024).decode().strip()
            if cmd.lower() in ('exit', 'quit'):
                break
            elif cmd.split()[0] not in ALLOWED_COMMANDS:
                conn.send(b"Command not allowed.\n")
                continue
            try:
                result = subprocess.check_output(cmd, shell=True, stderr=subprocess.STDOUT)
            except subprocess.CalledProcessError as e:
                result = e.output
            conn.send(result + b"\n")
    finally:
        conn.close()
        print(f"[-] Disconnected {addr}")

def start_server():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen()
        print(f"[+] Remote agent listening on port {PORT}...")
        while True:
            conn, addr = s.accept()
            client_thread = threading.Thread(target=handle_client, args=(conn, addr))
            client_thread.start()

if __name__ == "__main__":
    start_server()
